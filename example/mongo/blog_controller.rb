class BlogController < Rambo::Controller
  
  def index
    @posts = Post.find(:all, :order => 'created_at DESC')
    erb :posts
  end
  
  def post
    @post = Post.find(params[:id])
    erb :post
  end
  
  def create_comment
    post = Post.find(params[:id])
    post.comments << Comment.new(params[:comment])
    post.save
    redirect "/blog/post/#{post.id}"
  end
  
  def create_post
    post = Post.create(params[:post])
    redirect :index
  end
  
end