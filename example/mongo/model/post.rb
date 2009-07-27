class Post
  include MongoMapper::Document

  key :title, String, :required => true
  key :body, String, :required => true
  
  many :comments
end