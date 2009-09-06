class Post
  include MongoMapper::Document

  key :title, String, :required => true
  key :body, String, :required => true
  key :created_at, Time, :default => Time.now.utc, :required => true
  
  many :comments

  def slug
    self.title.downcase.gsub(' ', '-').gsub(/[^a-z0-9_\-']+/, "")
  end

end