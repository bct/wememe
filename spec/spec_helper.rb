ENV["RACK_ENV"] = "test"

require_relative '../rememe'

require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) { DataMapper.auto_migrate! }
end

def app
  Rememe
end

app.set :environment, :test
