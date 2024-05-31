# Change Log

## v4.4.0 (2024-05-31)

### Other Changes
* Allow Ruby 3.3 by @tvdeyen in https://github.com/blish/solidus_bookkeeping_documents/pull/15


**Full Changelog**: https://github.com/blish/solidus_bookkeeping_documents/compare/v4.3.0...v4.4.0

## v4.3.0 (2024-04-19)

### Features
* Add ransackable attributes to BookingDocument model by @sascha-karnatz in https://github.com/blish/solidus_bookkeeping_documents/pull/12
* Move from deface rb - files to deface files by @sascha-karnatz in https://github.com/blish/solidus_bookkeeping_documents/pull/13
### Other Changes
* Update dummy app to Rails v7.1 by @sascha-karnatz in https://github.com/blish/solidus_bookkeeping_documents/pull/14


**Full Changelog**: https://github.com/blish/solidus_bookkeeping_documents/compare/v4.2.0...v4.3.0

## v4.2.0 (2023-11-10)

### Features
* Allows Solidus 4.2 by @tvdeyen in https://github.com/blish/solidus_bookkeeping_documents/pull/10


**Full Changelog**: https://github.com/blish/solidus_bookkeeping_documents/compare/v4.1.0...v4.2.0

## v4.1.0 (2023-11-09)

### Features
* Allow Solidus 4.1 by @tvdeyen in https://github.com/blish/solidus_bookkeeping_documents/pull/9


**Full Changelog**: https://github.com/blish/solidus_bookkeeping_documents/compare/v4.0.0...v4.1.0

## v4.0.0 (2023-11-06)

### Features
* Allow PDF regeneration by @tvdeyen in https://github.com/blish/solidus_bookkeeping_documents/pull/7
### Breaking Changes
* Solidus 4.0 update by @sascha-karnatz in https://github.com/blish/solidus_bookkeeping_documents/pull/8

**Full Changelog**: https://github.com/blish/solidus_bookkeeping_documents/compare/v3.8.0...v4.0.0
# Changelog

## v3.8.0

- Update to Solidus 3.4

## v3.7.0

- Allow Ruby 3.2
- Only support Solidus 3.3

## v3.6.1

- Remove format and handler from template name

## v3.6.0

- Allow Solidus 3.3

## v3.5.1

- Move dev dependencies into Gemfile

## v3.5.0

- Fix solidus admin tab behavior
- Allow Ruby 3.1
- Allow Solidus 3.2

## v3.4.1

- Show link to order on documents list

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
