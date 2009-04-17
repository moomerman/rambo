class Comment
  include DataMapper::Resource
  
  property :id,         Integer,   :serial => true
  property :post_id,    Integer,   :nullable => false
  property :body,       Text,      :nullable => false
  property :created_at, DateTime
  property :updated_at, DateTime
  
  belongs_to :post
  
  after :create, :update_post
  
  def update_post
    self.post.update_attributes(
      :last_comment_at => self.updated_at
    )
  end
end
