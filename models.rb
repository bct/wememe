require 'dm-core'
require 'dm-timestamps'

class User
  include DataMapper::Resource

  property :id,         Serial
  property :username,   String, :required => true

  property :password_hash, String, :required => true

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end
end

class Url
  include DataMapper::Resource

  property :id,         Serial
  property :url,        String, :required => true

  has n, :linkings
end

class Linking
  include DataMapper::Resource

  property :id,         Serial
  property :summary,    String,   :required => true
  property :created_at, DateTime, :required => true

  belongs_to :url
  belongs_to :creater, User
  has n, :pools, :through => Resource
end

class Pool
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :required => true

  has n, :linkings, :through => Resource
end

DataMapper.finalize
