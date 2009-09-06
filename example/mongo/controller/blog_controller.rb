class BlogController < Rambo::Controller
  
  def index
    @posts = Post.find(:all, :order => 'created_at DESC')
    @posts = @posts.group_by{|x| x.created_at.to_date}
    erb :posts
  end

  def create_comment
    redirect '/' and return unless session[:user]
    post = Post.find(params[:id])
    post.comments << Comment.new(params[:comment].merge(:author => session[:user].screen_name))
    post.save
    redirect "/post/show/#{post.id}"
  end
  
end