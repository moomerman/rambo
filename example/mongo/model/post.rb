class Post
  include MongoMapper::Document

  key :title, String, :required => true
  key :url, String
  key :summary, String
  key :body, String, :required => true
  key :created_at, Time, :default => Time.now.utc, :required => true
  key :author, String, :required => true
  
  many :comments
  many :tags

  def slug
    self.title.downcase.gsub(/[^a-z0-9 ']+/, "").gsub(' ', '-')
  end

end