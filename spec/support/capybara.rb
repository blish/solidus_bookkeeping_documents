require "capybara/rspec"
require "capybara/rails"
require "capybara-screenshot/rspec"

Capybara.javascript_driver = :selenium_headless
Capybara.asset_host = "http://localhost:3000"
Capybara.server = :webrick
