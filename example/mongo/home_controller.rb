class HomeController < Rambo::Controller
  
  def init
    @@database ||= MongoMapper.database = 'mapper'
  end
  
  def index
    @posts = Post.all
    erb :posts
  end
  
  def post
    @post = Post.find(params[:id])
    erb :post
  end
  
  def comment
    post = Post.find(params[:id])
    post.comments << Comment.new(params[:comment])
    post.save
    redirect "/home/post/#{post.id}"
  end
  
  def create
    post = Post.create(params[:post])
    redirect :index
  end
  
end