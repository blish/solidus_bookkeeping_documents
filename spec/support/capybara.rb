require 'capybara/rspec'
require 'capybara/rails'
require "capybara-screenshot/rspec"
require "webdrivers/chromedriver"

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument("--headless")
    opts.add_argument("--disable-gpu") if Gem.win_platform?
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument("--disable-site-isolation-trials")
    opts.add_argument("--window-size=1920,1080")
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.asset_host = "http://localhost:3000"
Capybara.server = :webrick
