# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] = 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# FactoryBot::SyntaxRunner.class_eval do
#   include ActionDispatch::TestProcess
#   include ActiveSupport::Testing::FileFixtures

#   self.file_fixture_path = "spec/fixtures"
# end

Capybara.register_driver :headless_chrome do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << "--headless"
    opts.args << "--disable-gpu"
    opts.args << "--no-sandbox"
    opts.args << "--disable-dev-shm-usage"
    opts.args << "--lang=ja-JP"
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: browser_options)
end

Capybara.server = :puma, { Silent: true }

# Capybara.register_driver :selenium_chrome_headless do |app|
#   options = Selenium::WebDriver::Chrome::Options.new

#   [
#     "headless",
# ここの倍率を変更すれば、スクリーンショットサイズが変わります
#     "window-size=2880x2000",
#     "disable-gpu" # https://developers.google.com/web/updates/2017/04/headless-chrome
#   ].each { |arg| options.add_argument(arg) }

#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
# end

RSpec.configure do |config|
  # Webdrivers::Chromedriver.required_version = '114.0.5735.198'
  # Webdrivers::Chromedriver.required_version = "114.0.5735.90"
  # config.render_views
  # config.render_views = true

  config.include FactoryBot::Syntax::Methods
    config.before(:each) do |example|
      if example.metadata[:type] == :system
        if example.metadata[:js]
          driven_by :selenium, screen_size: [1400, 1400], using: :headless_chrome do |options|
            options.add_argument('--disable-dev-sim-usage')
            options.add_argument('--no-sandbox')
          end
        else
          driven_by :rack_test
        end
      end
    end
  config.include ActionDispatch::TestProcess

  config.include(RequestSpecHelper, type: :request)
  config.include(SystemSpecHelper, type: :system)
  # config.include(ApiRequestExampleGroup, type: :request)

  # config.before(:each, type: :system) do
  #   driven_by :rack_test
  # end

  config.before(:each, type: :system, js: true) do
    driven_by :headless_chrome
  end

  # Delete screenshots before starting new tests
  config.before(:all) do
    FileUtils.rm_rf(Rails.root.join('tmp', 'capybara'), secure: true)
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
