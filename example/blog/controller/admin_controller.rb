class AdminController < Rambo::Controller
  
  def init
    redirect 'login' unless (session[:admin] or action == 'login' or action == 'dologin')
    @blog = Blog.first
    redirect '/blog/new' unless @blog
  end
  
  def index
    erb :admin
  end
  
  def login  
    erb :login
  end
  
  def logout
    session[:admin] = nil
    redirect '/posts'
  end
  
  def dologin
    puts @blog.authorize?(params[:username], params[:password])
    if @blog.authorize?(params[:username], params[:password])
      session[:admin] = 'moo'
      redirect :index
    else
      redirect :login
    end
  end
  
end