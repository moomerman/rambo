require 'rambo/controller/template'
require 'rambo/controller/cache'
require 'rambo/controller/params'
require 'rambo/controller/redirect'

module Rambo
  class Controller
    attr_accessor :params, :request, :response
    
    include Template
    include Cache
    include Params
    include Redirect
    
    def controller
      self.request.controller
    end
  
    def action
      self.request.action
    end
  
  end
end