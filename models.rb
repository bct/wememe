class User
  include DataMapper::Resource

  property :id,         Serial
  property :username,   String, :length => 16, :required => true

  # I'm not sure what the actual length of this should be.
  property :password_hash, String, :length => 255, :required => true

  has n, :linkings, :child_key => [ :creator_id ]

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

  def gravatar_url options
    params = "?s=#{options[:size]}" if options[:size]
    "http://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50#{params}"
  end
end

class Url
  include DataMapper::Resource

  property :id,         Serial
  property :url,        String, :length => 255, :required => true

  has n, :linkings
end

class Linking
  include DataMapper::Resource

  property :id,         Serial
  property :summary,    String,   :length => 255, :required => true
  property :created_at, Time,     :required => true

  belongs_to :url,                :required => true
  belongs_to :creator, User,      :required => true

  has n, :pools, :through => Resource

  def other_linkings
    url.linkings.all(:id.not => id)
  end
end

class Pool
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :length => 64, :required => true

  has n, :linkings, :through => Resource
end

DataMapper.finalize
