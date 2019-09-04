require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless disable-gpu]
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome

RSpec.configure do |config|
  config.include Capybara::DSL
end
