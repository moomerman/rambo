require 'rack'

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
    
    def default_controller
      if Rambo::Env.config['rambo']
        Rambo::Env.config['rambo']['default_controller'] || 'home'
      else
        'home'
      end
    end
    
    def controller
      path_components[1] || default_controller
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
