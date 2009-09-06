class PostController < Rambo::Controller

  def create
    redirect '/' and return unless session[:user] and session[:user].admin?
    post = Post.create(params[:post].merge(:author => session[:user].screen_name))
    redirect '/'
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.reverse
    erb :post
  end

  def edit
    @post = Post.find(params[:id])
    erb :edit
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    redirect "/post/show/#{@post.id}"
  end

end