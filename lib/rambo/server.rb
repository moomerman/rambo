#!/usr/bin/env ruby

require 'rambo/env'
require 'rambo/controller'
require 'rambo/middleware'
require 'rambo/time'
require 'rambo/request'
require 'rambo/response'

# Server simply routes the request to the correct controller/action and returns the result
module Rambo
  class Server
    
    def initialize(options = {})
      @options = options
    end
  
    def call(env)
      begin
        request = Request.new(env)
        response = Response.new
        
        Rambo::Env.new
        
        # Could make this 'less magic'
        ctl_string = (request.controller.downcase.gsub(/^[a-z]|\s+[a-z]/) { |a| a.upcase } + 'Controller')
        begin
          controller = Object.module_eval("::#{ctl_string}", __FILE__, __LINE__).new
        rescue Exception => e
          return [404, response.header, "<h2>Routing error: controller <span style='color:grey'>#{request.controller}</span> not found</h2>"]
        end
        controller.request = request
        controller.response = response
        
        controller.init if controller.respond_to? :init 
        
        unless controller.respond_to? request.action
          return [404, response.header, "<h2>Routing error: action <span style='color:grey'>#{request.action}</span> not found in <span style='color:grey'>#{request.controller}</span></h2>"]
        end
        
        result = controller.send(request.action) unless controller.already_rendered?
        
        response.body = result if result
        
        [response.status, response.header, response.body]
      rescue Exception => e
        puts e.message
        return [500, response.header, "<pre><b>#{e.message.gsub("<","&lt;")}</b>\n#{e.backtrace.join("\n")}</pre>"]
      end
    end
  end
end
