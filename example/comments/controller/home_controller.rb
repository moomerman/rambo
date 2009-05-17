class HomeController < Rambo::Controller
  def init
    @user = User.get(session[:user])
  end
  
  def index
    if @user
      redirect :manage
    else
      erb :home
    end
  end
  
  def manage
    erb :manage
  end
  
end