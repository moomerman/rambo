class Account
  include DataMapper::Resource

  property :id,          Integer,   :serial => true
  property :uid,         String,    :nullable => false
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  belongs_to :user
  has n, :conversations
  
  before :valid?, :assign_uid
  
  private
    def assign_uid
      self.uid = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )[0..9]
    end
  
end