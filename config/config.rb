class Rememe
  set :haml, :escape_html => true

  # this is a workaround for an issue with sinatra and shotgun
  # <http://groups.google.com/group/sinatrarb/browse_thread/thread/a54152a32417c90b/16c06a6e43f643ec>
  set :session_secret, 'crazy about conan'
  enable :sessions

  use Rack::Flash

  configure :production do
    set :db, ENV['DATABASE_URL']
  end

  configure :development do
    set :db, "sqlite3:///#{Dir.pwd}/db/wememe.db"
  end

  configure :test do
    set :db, 'sqlite3::memory:'
  end
end
