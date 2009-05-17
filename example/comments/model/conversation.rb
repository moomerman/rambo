class Conversation
  include DataMapper::Resource

  property :id,          Integer,   :serial => true
  property :url,         String,    :nullable => false, :length => 500
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  belongs_to :account
  has n, :comments
  
end