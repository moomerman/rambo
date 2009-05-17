class User
  include DataMapper::Resource
  
  property :id,            Integer,   :serial => true
  property :username,      String,    :nullable => false
  property :access_token,  String,    :nullable => false
  property :access_secret, String,    :nullable => false
  property :avatar,        String,    :length => 500
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  has 1, :account
  
  def create_account!
    Account.create(:user => self)
  end
  
end