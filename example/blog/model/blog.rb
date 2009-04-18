class Blog
  include DataMapper::Resource
  
  property :id,          Integer,   :serial => true
  property :title,       String,    :nullable => false
  property :description, String,    :nullable => false
  property :username,    String,    :nullable => false
  property :password,    String,    :nullable => false
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  has n, :posts
  
  def authorize?(username, password)
    (username == self.username and password == self.password)
  end
  
end
