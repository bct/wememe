require 'bundler'
Bundler.require

class Rememe < Sinatra::Base
  get '/dev/styles' do
    haml :styles
  end

  get '/stylesheets/screen.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss :screen, Compass.sass_engine_options
  end
end
