# Solidus Bookkeeping Documents

This extension provides a model `Spree::BookkeepingDocument`, which generates PDFs from any Spree Object with the help of View objects that translate between different object structures and PDF templates. It stores a "number" string as well as first name, last name, email, and amount with each document for convenient searching in the backend.

The Gem contains an example implementation for Invoices for `Spree::Orders`. The basic structure looks like this:

`Spree::BookkeepingDocument` takes as constructor arguments a `printable` (polymorphic AR object) and a `template` (string). It then passes on all actual data generation to a ViewObject. You can find these objects in `app/spree/printables/#{printable}/#{template}_view.rb`. The object will be instantiated upon PDF generation (look at the `Spree::BookkeepingDocument#pdf` method to see how it's done).

`Spree::Order` is patched so that it generates both an invoice and a packaging_slip on completion.

In the `Spree::Admin::OrdersController#edit` view, you'll find an additional button `Documents`, where all printable documents will be listed. Additionally, you can find all available Documents in a "Documents" tab in the main menu.


## Installation

Add to your `Gemfile`
```ruby
gem 'solidus_bookkeeping_documents', git: 'https://gitlab.com/blish/gems/solidus_bookkeeping_documents', branch: 'main'
```

Run
```
bundle && bin/rails g solidus_bookkeeping_documents:install
```

Enjoy! Now you can generate invoices and packaging slips with sequential numbers from arbitrary Spree objects.

---

## Configuration

1. Set the logo path preference to include your store / company logo.

  ```ruby
  Spree::PrintInvoice::Config.set(logo_path: '/path/to/public/images/company-logo.png')
  ```

2. Add your own own footer texts to the locale. The current footer works with `:footer_left1` , `:footer_left2` and `:footer_right1`, `:footer_right2` where the 1 version is on the left in bold, and the 2 version the "value" on the right.

3. Override any of the partial templates.

4. Many european countries requires numeric and sequential invoices numbers. To use invoices sequential number fill the specific field in "General Settings" or by setting:

  ```ruby
  Spree::PrintInvoice::Config.set(next_number: [1|'your current next invoice number'])
  ```

  The next invoice number will be the one that you specified. You will able to increase it in any moment, for example, to re-sync invoices number if you are making invoices also in other programs for the same business name.

5. Set page/document options with:

  ```ruby
  Spree::PrintInvoice::Config.set(prawn_options: { page_layout: :landscape, page_size: 'A4', margin: [50, 100, 150, 200] })
  ```

## Customize templates

In order to customize the build in invoice and packaging slip templates you need to copy them into your app:

```sh
$ bundle exec rails g solidus_bookkeeping_documents:templates
```

You can then customize them in the `app/views/spree/printables` directory.

# Upgrading

From previous versions of `solidus_bookkeeping_documents`, the syntax and location of the `prawn` templates has changed. Please copy new templates using `rails g solidus_bookkeeping_documents:templates` and adapt according to your needs.

# Adding templates for another model

In order to create a packaging slip for `Spree::Shipment`s, do the following:

1. Create a View object in `app/models/printables/shipments/packagin_slip_view.rb`:

    ```ruby
    module Spree
      class Printables::Shipment::PackagingSlipView < Printables::BaseView
        def number
          @printable.number
        end

        # [ ... more code here, look at the BaseView to see what to implement ]

      end
    end
    ```

2. Create a `prawn` template in `app/views/spree/printables/shipment/packaging_slip.pdf.prawn`. You can find orientation on the format and syntax of the template by looking at the packaging slip template for `Spree::Orders` in `app/views/spree/printables/orders/invoice.pdf.prawn`. Some familiarity with Rails templates will help a lot, as well as reading the `prawn` docs.

3. Decorate the shipment model to generate a packaging slip at some point in its life cycle. You could go with a simple `after_create` Callback, or hook yourself into one of Spree's various state machines. Again, take the supplied `app/models/order_decorator.rb` as inspiration.

# Using Prawn for templating

This Gem uses the [`prawn-rails`](https://github.com/cortiz/prawn-rails) to generate templates.

## Usage

Name PDF view files like `foo.pdf.prawn`. Inside, use the `pdf` method to access a `Prawn::Document` object:

```ruby
pdf.bounding_box [100, 600], width: 200 do
  pdf.text 'The rain in spain falls mainly on the plains ' * 5
  pdf.stroke do
    pdf.line pdf.bounds.top_left,    pdf.bounds.top_right
    pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
  end
end
```

## S3 Setup

Configure a S3 datastore for Dragonfly

```ruby
# config/initializers/dragonfly

require "dragonfly/s3_data_store"

Dragonfly.app(:solidus_bookkeeping_documents).configure do
  datastore :s3,
    bucket_name: ENV.fetch("SOLIDUS_BOOKKEEPING_DOCUMENTS_S3_BUCKET_NAME"),
    access_key_id: ENV.fetch("SOLIDUS_BOOKKEEPING_DOCUMENTS_S3_ACCESS_KEY_ID"),
    secret_access_key: ENV.fetch("SOLIDUS_BOOKKEEPING_DOCUMENTS_S3_SECRET_ACCESS_KEY"),
    region: ENV.fetch("SOLIDUS_BOOKKEEPING_DOCUMENTS_S3_REGION")
end
```

## Troubleshooting

When you customize templates and you get the message "You have reached the end of the graphics stack", any one of the objects you're trying to place on your template is too big for the surrounding `bounding_box`. A common source of this is a missing translation, so make sure your translations are up-to-date.

---

## Contributing

See corresponding [guidelines][1]

---

## License

Copyright (c) 2020 [Blish][2], and other [contributors][3], released under the [New BSD License][4]

[1]: https://gitlab.com/blish/gems/solidus_bookkeeping_documents/blob/main/CONTRIBUTING.md
[2]: https://blish.cloud
[3]: https://gitlab.com/blish/gems/solidus_bookkeeping_documents/contributors
[4]: https://gitlab.com/blish/gems/solidus_bookkeeping_documents/blob/main/LICENSE.md
