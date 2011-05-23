ENV["RACK_ENV"] = "test"

require_relative '../rememe'

require 'rspec'
require 'rack/test'

def app
  Rememe
end

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    DataMapper.auto_migrate!

    app.class_eval do
      helpers do
        def current_user; nil; end
      end
    end
  end
end

app.set :environment, :test
