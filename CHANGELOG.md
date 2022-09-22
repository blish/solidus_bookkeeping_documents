# Changelog

## v3.4.0

- Allow Solidus 3.1
- Test Rails 6.1 and Rails 6.0
- Create a country for each order address
- Use ActionController::Renderer to render PDFs from model

## v3.3.0

- Use correct address for templates
- Remove firstname and lastname from base views
- Add deprecation class
- Remove extension from Dragonfly url
- Use Rails credentials instead of secrets
- Use document number as pdf file_name

## v3.2.0

- Use number formatting in admin documents table
- Use name in admin documents table

## v3.1.0

- Add name to spree_bookkeeping_documents
- Wrap spree initializer in config.to_prepare hook
- Run Solidus 3 specs with Ruby 3
- Allow Ruby 3.0
- Use Spree::Address::Name for invoice view

## v3.0.0

- Use dynamic attributes in factories
- Use solidus_support and move decorators
- Namespace OrderDecorator
- Convert Spree::OrderDecorator in module
- Test with Rails 6.0
- Test Solidus 2.11 and 3.0
- Use solidus v3.0 branch for testing
- Use name for address in factory
- Explicitly require spree/preferences/persistable
- Use solidus_dev_support for testing
- Allow Solidus 3.0
