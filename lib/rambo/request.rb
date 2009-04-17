module Rambo
  class Request < Rack::Request
    def user_agent
      @env['HTTP_USER_AGENT']
    end

    # Returns an array of acceptable media types for the response
    def accept
      @env['HTTP_ACCEPT'].to_s.split(',').map { |a| a.strip }
    end
  
    def path
      env["REQUEST_PATH"]
    end
  
    def uri
      env["REQUEST_URI"]
    end
  
    def path_components
      @path_components ||= path.split('/')
    end
  
    def controller
      path_components[1] || 'home'
    end
  
    def action
      path_components[2] || 'index'
    end
  
    # Override Rack 0.9.x's #params implementation (see #72 in lighthouse)
    def params
      self.GET.update(self.POST)
    rescue EOFError => boom
      self.GET
    end
  end
end