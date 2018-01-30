require 'rubygems'
require 'bundler/setup'
require 'liveqa'
require 'rspec'
require 'pry'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec

  config.before(:each) do
    LiveQA.configure do |config|
      config.api_host  = 'localhost:4003'
      config.account_token = 'acc_xx'
      config.space_name = 'LiveQA'
      config.environment_name = 'test'
      config.http_secure = false
    end
  end

  config.after(:each) do
    LiveQA::Store.clear!
  end

  config.before(:each) do
    LiveQA::Store.clear!
  end

end
