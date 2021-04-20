module Spree
  class BookkeepingDocument < ActiveRecord::Base
    extend Dragonfly::Model

    PERSISTED_ATTRS = [
      :firstname,
      :lastname,
      :email,
      :total,
      :number
    ]

    # Spree::BookkeepingDocument cares about creating PDFs. Whenever it needs to know
    # anything about the document to send to the view, it asks a view object.
    #
    # +printable+ should be an Object, such as Spree::Order or Spree::Shipment.
    # template should be a string, such as "invoice" or "packaging_slip"
    #
    belongs_to :printable, polymorphic: true
    validates :printable, :template, presence: true
    validates *PERSISTED_ATTRS, presence: true, if: -> { self.persisted? }
    scope :invoices, -> { where(template: 'invoice') }

    # Store next document number
    before_create :store_next_document_number
    before_create :persist_view_attributes

    dragonfly_accessor :attachment, app: :solidus_bookkeeping_documents

    class << self

      # The maximum document number from all invoice documents
      #
      # You may pass a scope
      #
      def current_document_number(number_scope = nil)
        where(number_scope).maximum(:document_number)
      end
    end

    # An instance of Spree::Printable::#{YourModel}::#{YourTemplate}Presenter
    #
    def view
      @_view ||= view_class.new(printable, self)
    end

    def date
      created_at.to_date
    end

    def template_name
      "spree/printables/#{single_lower_case_name(printable.class.name)}/#{template}"
    end

    # If the document is called from the view with some method it doesn't know,
    # just call the view object. It should know.
    def method_missing(method_name, *args, &block)
      if view.respond_to? method_name
        view.send(method_name, *args, &block)
      else
        super
      end
    end

    def document_type
      "#{printable_type.demodulize.tableize.singularize}_#{template}"
    end

    # Returns the given template as pdf binary suitable for Rails send_data
    #
    # If the file is already present it returns this
    # else it generates a new file, stores and returns this.
    #
    # You can disable the pdf file generation with setting
    #
    #   Spree::PrintInvoice::Config.store_pdf to false
    #
    def pdf
      send_or_create_pdf
    end

    # = The PDF file_name
    #
    def file_name
      @_file_name ||= "#{template}-D#{id}-N#{number}.pdf"
    end

    # = PDF file path
    #
    def file_url
      return attachment.url unless attachment.app.datastore.class.name == "Dragonfly::S3DataStore"
      attachment.remote_url
    end
    alias_method :file_path, :file_url

    # Renders the prawn template for give template name in context of ActionView.
    #
    # Prawn templates need to be placed in the correct folder. For example, for a PDF from
    # a Spree::Order with the invoice template, it would be
    # the +app/views/spree/printables/order/invoices+ folder.
    #
    # Assigns +@doc+ instance variable
    #
    def render_pdf
      ActionView::Base.new(
        ActionController::Base.view_paths,
        {
          doc: self,
          printable: self.printable
        }
      ).render(template: "#{template_name}.pdf.prawn")
    end

    # Get document number from database and increments it
    #
    # If no document number is present we use the value from the configuration.
    # If nothing is configured we fall back to 1.
    #
    def next_document_number
      self.class.current_document_number(number_scope).try(:+, 1) ||
        Spree::PrintInvoice::Config.next_number || 1
    end

    def formatted_number
      if (Object.const_get('::Spree::PrintInvoice::NumberFormatter') rescue false)
        Spree::PrintInvoice::NumberFormatter.new(document_number_prefix, document_number).to_s
      else
        "#{document_number_prefix}#{document_number}"
      end
    end

    private

    def store_next_document_number
      self.document_number_prefix = number_prefix
      self.document_number = next_document_number
      self.number = formatted_number
    end

    # Scope that gets passed to +where+ in +Spree::BookkeepingDocument.current_document_number+
    def number_scope
      return unless number_prefix
      {
        document_number_prefix: number_prefix
      }
    end

    # Ask the +view+ class, if a +document_number_prefix+ is configured
    def number_prefix
      view_class.try(:document_number_prefix)
    end

    def persist_view_attributes
      PERSISTED_ATTRS.each do |attr|
        send("#{attr}=", view.send(attr))
      end
    end

    # For a Spree::Order printable and an "invoice" template,
    # you would get "spree/documents/order/invoice_view"
    # --> Spree::Printables::Order::InvoiceView
    #
    def view_class
      @_view_class ||= "#{template_name}_view".classify.constantize
    end

    def single_lower_case_name(class_string)
      @_single_lower_class_name ||= class_string.demodulize.tableize.singularize
    end

    # Sends stored pdf for given template from disk.
    #
    # Renders and stores it if it's not yet present.
    #
    def send_or_create_pdf
      unless attachment_stored?
        self.attachment = render_pdf
        save
      end

      IO.binread(attachment.file)
    end
  end
end
