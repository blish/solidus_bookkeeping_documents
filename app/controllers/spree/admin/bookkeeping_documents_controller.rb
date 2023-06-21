module Spree
  module Admin
    class BookkeepingDocumentsController < ResourceController
      before_action :load_order, if: :order_focused?
      before_action :set_document_type, only: [:index]
      helper_method :order_focused?

      def show
        respond_with(@bookkeeping_document) do |format|
          format.pdf do
            send_data @bookkeeping_document.pdf, filename: @bookkeeping_document.file_name, type: "application/pdf", disposition: "inline"
          end
        end
      end

      def index
        # Massaging the params for the index view like Spree::Admin::Orders#index
        params[:q] ||= {}
        params[:q][:s] ||= "created_at desc"
        @search = Spree::BookkeepingDocument.ransack(params[:q])
        @bookkeeping_documents = @search.result.includes(:printable)
        @bookkeeping_documents = @bookkeeping_documents.where(printable: @order) if order_focused?
        @bookkeeping_documents = @bookkeeping_documents.page(params[:page] || 1).per(10)
      end

      def destroy
        @bookkeeping_document.attachment = nil
        if @bookkeeping_document.save
          flash[:success] = t(".successfully_remove_attachment")
        end

        respond_with(@object) do |format|
          format.html { redirect_to location_after_destroy }
          format.js { render partial: "spree/admin/shared/destroy" }
        end
      end

      private

      def order_focused?
        params[:order_id].present?
      end

      def load_order
        @order = Spree::Order.find_by(number: params[:order_id])
      end

      def set_document_type
        @document_type ||= case params.fetch(:q, {})["template_cont"].to_s
          when /invoice/
            "invoices"
          when /packaging\_slip/
            "packaging_slips"
          else
            "documents"
          end
      end
    end
  end
end
