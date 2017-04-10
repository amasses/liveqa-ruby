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
      config.api_key   = 'MVulkyYgAf1Xqc09eLbvONymxZCSwA-yevXRsBHx226lxdwIs5ppG942'
      config.http_secure = false
    end
  end

end
