class HomeController < Rambo::BaseController
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