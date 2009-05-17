require 'twitter_oauth'
class OauthController < Rambo::Controller
  
  def connect
    request_token = oauth_client.request_token
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect request_token.authorize_url.gsub('authorize', 'authenticate')
  end
  
  def auth
    # Exchange the request token for an access token.
    access_token = oauth_client.authorize(
      session[:request_token],
      session[:request_token_secret]
    )

    session[:request_token] = nil
    session[:request_token_secret] = nil

    client = oauth_client(access_token.token, access_token.secret)

    if client.authorized?
      
      info = client.info
      username = info['screen_name']
      avatar = info['profile_image_url'] 
      
      if user = User.first(:username => username)
        user.update_attributes(:avatar => avatar)
      else
        user = User.create!(
          :username => username,
          :avatar => avatar,
          :access_token => access_token.token,
          :access_secret => access_token.secret
        )
      end
      session[:user] = user.id
      
      if session[:comment]
        redirect '/comments/new' and return
      else
        user.create_account!
      end
      
      redirect '/'
    end
  end
   
  private
    def oauth_client(token = nil, secret = nil)
      config = Rambo::Env.config
      @client = TwitterOAuth::Client.new(
        :consumer_key => config['oauth']['consumer_key'],
        :consumer_secret => config['oauth']['consumer_secret'],
        :token => token,
        :secret => secret
      )
    end
end