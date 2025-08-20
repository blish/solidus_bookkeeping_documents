source "https://rubygems.org"

gemspec

gem "rails", "~> 8.0"
gem "solidus_frontend", "~> 3.4"
gem "listen"
gem "pry-rails", ">= 0.3.0"
gem "sqlite3", "~> 2.0"
gem "sassc-rails", "~> 2.1"
gem "selenium-webdriver", "~> 4.19"
gem "state_machines", "< 0.10"

source "https://rubygems.pkg.github.com/blish" do
  gem "blish-support", require: false
end

group :test do
  gem "simplecov", "~> 0.10"
  gem "pdf-inspector", "~> 1.2"
  gem "rails-controller-testing"
  gem "solidus_dev_support"
end

group :utils do
  gem "standard", ">= 1.0", require: false
  gem "rubocop", require: false
end
