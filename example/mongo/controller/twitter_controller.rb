require 'twitter_oauth'

class TwitterController < Rambo::Controller

  def connect    
    request_token = oauth_client.authentication_request_token
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect request_token.authorize_url
  end
  
  def oauth
    # Exchange the request token for an access token.
    
    begin
      access_token = oauth_client.authorize(
        session[:request_token],
        session[:request_token_secret]
      )
    rescue
      redirect '/' and return
    end
    
    session[:request_token] = nil
    session[:request_token_secret] = nil
    
    client = oauth_client(access_token.token, access_token.secret)
    
    if client.authorized?
      
      puts("OAuth authorization: #{client.info['screen_name']}")
      
      session[:access_token] = access_token.token
      session[:access_secret] = access_token.secret
      
      user = User.new
      user.screen_name = client.info['screen_name']
      user.token = access_token.token
      user.secret = access_token.secret
      session[:user] = user
      
      #twitter_account = TwitterAccount.find_by_screen_name(client.info['screen_name'])
      #twitter_account.update_attributes(
      #  :access_token => access_token.token,
      #  :access_secret => access_token.secret
      #)
      
      redirect '/'
    else
      redirect '/'
    end
  
  end
  
  private
    def oauth_client(token=nil, secret=nil)
      token ||= session[:access_token]
      secret ||= session[:access_secret]
      #@@config ||= YAML.load_file(File.join(RAILS_ROOT, "config/oauth.yml")) rescue nil || {}
      @@config = {}
      @@config['consumer_key'] = ''
      @@config['consumer_secret'] = ''
      @client = TwitterOAuth::Client.new(
        :consumer_key => @@config['consumer_key'],
        :consumer_secret => @@config['consumer_secret'],
        :token => token,
        :secret => secret
      )
    end
  
end