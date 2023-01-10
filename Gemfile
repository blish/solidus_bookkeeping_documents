source "https://rubygems.org"

gemspec

solidus_version = ENV.fetch("SOLIDUS_VERSION", "v3.2")

gem "rails", "~> 6.1.5"

gem "solidus_core", github: "solidusio/solidus", branch: solidus_version
gem "solidus_backend", github: "solidusio/solidus", branch: solidus_version

if solidus_version == "v3.2"
  gem "solidus_frontend", "~> 3.2"
end

# Remove after https://github.com/solidusio/solidus/pull/4734 has been merged
if RUBY_VERSION.match?(/^3\.1/)
  gem "mail", [">= 2.8.0.rc1", "< 3"]
end

gem "listen"
gem "pry-rails", ">= 0.3.0"
gem "sqlite3", "~> 1.4"
gem "sassc-rails", "~> 2.1"
gem "coffee-rails", "~> 4.1"

group :test do
  gem "simplecov", "~> 0.10"
  gem "pdf-inspector", "~> 1.2"
  gem "rails-controller-testing"
  gem "solidus_dev_support"
end
