source "https://rubygems.org"

gemspec

gem "rails", "~> 5.1"
gem "puma", "~> 5.4"

gem "solidus_core", github: "solidusio/solidus", branch: "v2.11"
gem "solidus_backend", github: "solidusio/solidus", branch: "v2.11"

if ENV["CI"]
  gem "rspec_junit_formatter", "~> 0.4"
end
