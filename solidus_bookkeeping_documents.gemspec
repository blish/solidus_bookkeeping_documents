require_relative "lib/solidus_bookkeeping_documents/version"

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "solidus_bookkeeping_documents"
  s.version = SolidusBookkeepingDocuments::VERSION
  s.summary = "Print invoices and packing slips from Solidus Orders"
  s.description = s.summary
  s.required_ruby_version = [">= 3.0", "< 4"]

  s.authors = ["Thomas von Deyen", "Martin Meyerhoff"]
  s.email = "hello@blish.cloud"
  s.homepage = "https://github.com/blish/solidus_bookkeeping_documents"
  s.license = "BSD-3"

  if s.respond_to?(:metadata)
    s.metadata = {
      "allowed_push_host" => "https://rubygems.pkg.github.com/blish",
      "changelog_uri" => "https://github.com/blish/solidus_bookkeeping_documents/blob/main/CHANGELOG.md",
      "source_code_uri" => "https://github.com/blish/solidus_bookkeeping_documents",
      "bug_tracker_uri" => "https://github.com/blish/solidus_bookkeeping_documents/issues"
    }
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/|bin}) }

  s.add_runtime_dependency "prawn-rails", "~> 1.0"
  s.add_runtime_dependency "deface", "~> 1.0"
  s.add_runtime_dependency "dragonfly", "~> 1.0"
  s.add_runtime_dependency "solidus_core", ["~> 4.0", "< 5"]
  s.add_runtime_dependency "solidus_backend", ["~> 4.0", "< 5"]
  s.add_runtime_dependency "solidus_support", [">= 0.14.1", "< 1"]
end
