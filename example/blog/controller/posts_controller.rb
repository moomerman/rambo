class PostsController < Rambo::Controller
  
  def index
    @posts = Post.all(:order => [:created_at.desc])
    unless fresh?(@posts.first)
      erb :posts
    end
  end
  
  def show
    @post = Post.get(params[:id])
    unless fresh?(@post)
      @comments = @post.comments.all(:order => [:created_at.desc])
      erb :post
    end
  end
  
  def new
    erb :post_new
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect "/posts/show/#{@post.id}"
    else
      erb :post_new
    end
  end
  
  def comment
    @post = Post.get(params[:id])
    @post.comments.create(params[:comment])
    redirect "/posts/show/#{@post.id}"
  end
  
end