require 'bundler'
Bundler.require

require_relative 'models'

class Rememe < Sinatra::Base
  configure do
    set :db, "sqlite3:///#{Dir.pwd}/db/wememe.db"
  end

  get '/' do
    haml :index
  end

  get '/login' do
    haml :login
  end

  get '/dev/styles' do
    haml :styles
  end

  get '/stylesheets/screen.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :screen, Compass.sass_engine_options
  end
end

#DataObjects::Sqlite3.logger = DataMapper::Logger.new(STDOUT, :debug)

DataMapper.setup :default, Rememe.db
