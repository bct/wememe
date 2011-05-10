require 'bundler'
Bundler.require

require_relative 'models'

class Rememe < Sinatra::Base
  enable :sessions
  use Rack::Flash

  helpers do
    def signed_in?
      current_user
    end

    def sign_in user
      # TODO: this has to be tamper-proof
      session[:user] = user.id
    end

    def current_user
      @current_user ||= load_user_from_session
    end

    def load_user_from_session
      p session
      User.get(session[:user])
    end
  end

  configure do
    set :db, "sqlite3:///#{Dir.pwd}/db/wememe.db"
  end

  get '/' do
    haml :index
  end

  get '/login' do
    haml :login
  end

  post '/login' do
    @u = User.first(:username => params[:username])
    sign_in(@u)
    redirect url('/')
  end

  post '/accounts' do
    if params[:password] == params[:'password-again']
      @u = User.create :username => params[:username], :password => params[:password]
      sign_in(@u)
      redirect url('/')
    else
      flash[:error] = "Passwords do not match."
      haml :login
    end
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
DataMapper.auto_upgrade!
