require_relative "lib/solidus_bookkeeping_documents/version"

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "solidus_bookkeeping_documents"
  s.version = SolidusBookkeepingDocuments::VERSION
  s.summary = "Print invoices and packing slips from Solidus Orders"
  s.description = s.summary
  s.required_ruby_version = [">= 2.5", "< 3.1"]

  s.authors = ["Thomas von Deyen", "Martin Meyerhoff"]
  s.email = "hello@blish.cloud"
  s.homepage = "https://gitlab.com/blish/solidus_bookkeeping_documents"
  s.license = "BSD-3"

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/|bin}) }
  s.test_files = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^spec/}) }

  s.add_runtime_dependency "prawn-rails", "~> 1.0"
  s.add_runtime_dependency "deface", "~> 1.0"
  s.add_runtime_dependency "dragonfly", "~> 1.0"

  s.add_runtime_dependency "solidus_core", [">= 2.11.0", "< 3.2"]
  s.add_runtime_dependency "solidus_backend", [">= 2.11.0", "< 3.2"]
  s.add_runtime_dependency "solidus_support", ["~> 0.7"]

  s.add_development_dependency "bourbon", ">= 4", "< 5"
  s.add_development_dependency "simplecov", "~> 0.10"
  s.add_development_dependency "coffee-rails", "~> 4.1"
  s.add_development_dependency "sass-rails", "~> 5.0"
  s.add_development_dependency "pdf-inspector", "~> 1.2"
  s.add_development_dependency "guard-rspec", ">= 4.2.0"
  s.add_development_dependency "pry-rails", ">= 0.3.0"
  s.add_development_dependency "sqlite3", "~> 1.4"
  s.add_development_dependency "listen"
  s.add_development_dependency "rake"
  s.add_development_dependency "rails-controller-testing"
  s.add_development_dependency "solidus_dev_support"
end
