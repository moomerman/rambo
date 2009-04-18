class AdminController < Rambo::Controller
  
  def init
    redirect 'login' unless (session[:admin] or action == 'login')
    @blog = Blog.first
    redirect '/blog/new' unless @blog
  end
  
  def index
    erb :admin
  end
  
  def login  
    erb :login
  end
  
  def dologin
    if @blog.authorize?(params[:username], params[:password])
      redirect :index
    else
      redirect :login
    end
  end
  
end