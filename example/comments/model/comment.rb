class Comment
  include DataMapper::Resource
  
  property :id,          Integer,   :serial => true
  property :message,     String,    :nullable => false
  property :tweet,       Boolean,   :nullable => false, :default => false
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  belongs_to :user
  belongs_to :conversation
end