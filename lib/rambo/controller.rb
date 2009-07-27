require 'rambo/controller/template'
require 'rambo/controller/cache'
require 'rambo/controller/params'
require 'rambo/controller/redirect'

module Rambo
  class Controller
    attr_accessor :request, :response
    
    include Template
    include Cache
    include Params
    include Redirect
    
    def already_rendered?
      @rendered
    end
    
    def controller
      self.request.controller
    end
  
    def action
      self.request.action
    end
  
    def session
      request.env['rack.session'] ||= {}
    end
    
    def host
      self.request.env['HTTP_HOST']
    end
    
  end
end