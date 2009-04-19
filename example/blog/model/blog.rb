class Blog
  include DataMapper::Resource
  
  attr_accessor :password
  
  property :id,          Integer,   :serial => true
  property :title,       String,    :nullable => false
  property :description, String,    :nullable => false
  property :username,    String,    :nullable => false
  property :salt,        String,    :nullable => false
  property :hashed_password,    String,    :nullable => false
  property :created_at,  DateTime
  property :updated_at,  DateTime
  
  has n, :posts
  
  before :valid?, :hash_password
  
  def self.authenticate(username, password)
    if blog = Blog.first(:username => username)
      return blog if blog.authenticate(password) || false
    end
  end
  
  def authenticate(password)
    generate_hash(password) == self.hashed_password
  end
  
  private
    def hash_password
      return if self.password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.username}--")
      self.hashed_password = generate_hash(self.password)
    end
    
    def generate_hash(password)
      Digest::SHA1.hexdigest("--#{self.salt}--#{password}--")
    end
end
