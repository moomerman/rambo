class BlogController < Rambo::Controller
  
  def init
    @blog = Blog.first
  end
  
  def new
    erb :blog_new
  end
  
  def create
    blog = Blog.new(params[:blog])
    if blog.save
      redirect '/posts'
    else
      erb :blog_new
    end 
  end
  
end