class PostController < Rambo::Controller

  def create
    post = Post.create(params[:post])
    redirect '/'
  end

  def show
    @post = Post.find(params[:id])
    erb :post
  end

  def edit
    @post = Post.find(params[:id])
    erb :edit
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    redirect '/'
  end

end