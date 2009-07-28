module Blog
  class BlogController < Rambo::Controller
    def index
      "hello from the blog controller"
    end
    
    def blegga
      haml :blegga
    end
    
    def test
      erb :test
    end
    
  end
end