class Comment
  include MongoMapper::EmbeddedDocument

  key :message, String, :required => true
  key :author, String, :required => true
  key :created_at, Time, :default => Time.now.utc, :required => true
  
end