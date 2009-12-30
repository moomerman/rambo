class PostsController < Rambo::Controller
  
  def init
    @@blog ||= Blog.first
    @blog = @@blog
    redirect '/blog/new' unless @blog
    redirect '/admin/login' unless session[:admin] or (['index', 'show', 'comment'].include? action)
  end
  
  def index
    @posts = Post.all(:order => [:created_at.desc])
    #unless fresh?(@posts.first)
      erb :posts
    #end
  end
  
  def show
    @post = Post.get(params[:id])
    #unless fresh?(@post)
      @comments = @post.comments.all(:order => [:created_at.desc])
      erb :post
    #end
  end
  
  def new
    erb :post_new
  end
  
  def create
    @post = Post.new(params[:post].merge(:blog_id => @blog.id, :created_at => Time.now.utc))
    if @post.save
      redirect "show/#{@post.id}"
    else
      erb :post_new
    end
  end
  
  def comment
    @post = Post.get(params[:id])
    @post.comments.create(params[:comment])
    redirect "show/#{@post.id}"
  end
  
end