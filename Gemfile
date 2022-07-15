source "https://rubygems.org"

gemspec

gem "rails", "~> 6.0.5"

ENV.fetch("SOLIDUS_VERSION", "v3.0").tap do |version|
  gem "solidus_core", github: "solidusio/solidus", branch: version
  gem "solidus_backend", github: "solidusio/solidus", branch: version
end
