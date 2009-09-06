class BlogController < Rambo::Controller
  
  def index
    @posts = Post.find(:all, :order => 'created_at DESC')
    @posts = @posts.group_by{|x| x.created_at.to_date}
    erb :posts
  end

  def create_comment
    post = Post.find(params[:id])
    post.comments << Comment.new(params[:comment])
    post.save
    redirect "/blog/post/#{post.id}"
  end
  
end