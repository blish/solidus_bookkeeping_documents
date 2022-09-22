source "https://rubygems.org"

gemspec

solidus_version = ENV.fetch("SOLIDUS_VERSION", "v3.1")

if solidus_version == "v2.11"
  gem "rails", "~> 6.0.5"
else
  gem "rails", "~> 6.1.5"
end

gem "solidus_core", github: "solidusio/solidus", branch: solidus_version
gem "solidus_backend", github: "solidusio/solidus", branch: solidus_version
