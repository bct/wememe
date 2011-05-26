#!/usr/bin/env ruby

require 'bundler'
Bundler.require

require 'json'

class Rememe < Sinatra::Base; end

require_relative 'models'
require_relative 'config/config'

class Rememe
  helpers do
    def signed_in?
      current_user
    end

    def sign_in user
      # TODO: this has to be tamper-proofed
      session[:user] = user.id
    end

    def logout
      session[:user] = nil
    end

    def current_user
      @current_user ||= load_user_from_session
    end

    def load_user_from_session
      User.get(session[:user])
    end
  end

  get '/' do
    @linkings = Linking.all
    haml :index
  end

  get '/login' do
    haml :login
  end

  post '/login' do
    @u = User.first(:username => params[:username])
    if @u and @u.password == params[:password]
      sign_in(@u)
      redirect url('/')
    else
      flash[:error] = "Bad username or password."
      redirect url('/login')
    end
  end

  get '/logout' do
    logout
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

  post %r{/linkings(\.json)?} do |format|
    @u = Url.first_or_create(:url => params[:url])
    @l = Linking.create :url => @u, :summary => params[:summary], :creator => current_user

    if format == ".json"
      @l.to_json
    else
      flash[:notice] = "Posted new link."
      redirect url("/users/#{current_user.username}")
    end
  end

  get '/dev/styles' do
    haml :styles
  end

  get '/stylesheets/screen.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :screen, Compass.sass_engine_options
  end

  get '/users/:username' do
    @user = User.first(:username => params[:username])
    haml :user
  end
end

#DataObjects::Sqlite3.logger = DataMapper::Logger.new(STDOUT, :debug)

DataMapper.setup :default, Rememe.db
DataMapper.auto_upgrade!
