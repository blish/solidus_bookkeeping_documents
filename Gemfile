source "https://rubygems.org"

gemspec

solidus_version = ENV.fetch("SOLIDUS_VERSION", "v3.2")

gem "rails", "~> 6.1.5"

gem "solidus_core", github: "solidusio/solidus", branch: solidus_version
gem "solidus_backend", github: "solidusio/solidus", branch: solidus_version
