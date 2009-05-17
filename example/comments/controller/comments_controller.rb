class CommentsController < Rambo::Controller
  def init
    @user = User.get(session[:user])
  end
  
  def index
    erb :comments
  end
  
  def embed
    @host = host
    @account = Account.first(:uid => params[:id])
    unless @conversation = Conversation.first(:url => params[:url], :account_id => @account.id)
      @conversation = Conversation.new(:url => params[:url], :account => @account)
    end
    
    response.header['Content-Type'] = 'text/javascript'
    erb :embed, :layout => false
  end
  
  def new

    unless @user
      session[:comment] = {:comment => params[:comment], :tweet => params[:tweet], :location => params[:location], :account_id => params[:id]}
      redirect '/oauth/connect' and return
    end
    
    if session[:comment]
      @account = Account.first(:uid => session[:comment][:account_id])
      puts @account.inspect
      params[:comment] = session[:comment][:comment]
      params[:tweet] = session[:comment][:tweet]
      params[:location] = session[:comment][:location]
      session[:comment] = nil
    end
    
    @account ||= Account.first(:uid => params[:id])
    
    puts @account.inspect
    
    unless conversation = Conversation.first(:url => params[:location], :account_id => @account.id)
      conversation = Conversation.create!(:url => params[:location], :account_id => @account.id)
    end
    
    conversation.comments.create(:message => params[:comment], :user => @user)
    if params[:tweet] and params[:tweet] == 'yes'
      oauth_client.update("comment: #{params[:comment]}")
    end
    if params[:location]
      redirect params[:location] + '#comments'
    else
      "comment posted"
    end
  end
  
  private
    def oauth_client(token = nil, secret = nil)
      config = Rambo::Env.config
      @client = TwitterOAuth::Client.new(
        :consumer_key => config['oauth']['consumer_key'],
        :consumer_secret => config['oauth']['consumer_secret'],
        :token => @user.access_token,
        :secret => @user.access_secret
      )
    end
  
end