class User
  ADMIN = 'moomerman' unless defined? ADMIN
  attr_accessor :screen_name, :token, :secret
  
  def admin?
    ADMIN == self.screen_name
  end
  
end