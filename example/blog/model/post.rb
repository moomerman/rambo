class Post
  include DataMapper::Resource
  
  property :id,         Integer,   :serial => true
  property :title,      String,    :nullable => false
  property :body,       Text,      :nullable => false
  property :last_comment_at, DateTime
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has n, :comments
end
