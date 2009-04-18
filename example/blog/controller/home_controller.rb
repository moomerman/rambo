class HomeController < Rambo::Controller
  def index
    "Hello zzzasdasdkjhaskjh #{Time.now}"
  end
  
  def foo
    request.params.inspect
  end
  
  def string
    "MOO"
  end
  
end