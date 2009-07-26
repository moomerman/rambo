require 'mongomapper'

class Comment
  include MongoMapper::EmbeddedDocument

  key :message, String, :required => true
end