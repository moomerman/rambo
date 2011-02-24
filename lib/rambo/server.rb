#!/usr/bin/env ruby

require 'rambo/colored'
require 'rambo/env'
require 'rambo/controller'
require 'rambo/middleware'
require 'rambo/time'
require 'rambo/request'
require 'rambo/application_request'
require 'rambo/response'
require 'rambo/application_context'

# Server simply routes the request to the correct controller/action and returns the result
module Rambo
  class Server
    
    def initialize(options = {})
      @options = options
      env = Rambo::Env.new
      @contexts = {
        'default' => Rambo::ApplicationContext.new(),
        #'blog' => Rambo::ApplicationContext.new('blog')
      }
    end
    
    def call(env)
      begin
        @contexts.each { |key, context| context.reload } if Rambo::Env.config
        
        request = Request.new(env)
        response = Response.new
        
        if @contexts.keys.include? request.controller.downcase
          current_context = @contexts[request.controller.downcase]
          request = Rambo::ApplicationRequest.new(env)
        end
        current_context ||= @contexts['default']
        request.application_context = current_context
        
        #puts "rambo: looking for #{request.controller_class}"
        
        begin
          controller = Object.module_eval("::#{request.controller_class}", __FILE__, __LINE__).new
        rescue Exception => e
          return [404, response.header, ["<h2>Routing error: controller <span style='color:grey'>#{request.controller}</span> not found</h2>"]]
        end
        controller.request = request
        controller.response = response
        
        controller.init if controller.respond_to? :init 
        
        unless controller.respond_to? request.action
          return [404, response.header, ["<h2>Routing error: action <span style='color:grey'>#{request.action}</span> not found in <span style='color:grey'>#{request.controller}</span></h2>"]]
        end
        
        result = controller.send(request.action) unless controller.already_rendered?
        result = [result] if result.is_a? String # ruby1.9
        
        response.body = result if result
        response.body = [] if request.head?
        
        [response.status, response.header, response.body]
      rescue Exception => e
        puts e.message
        return [500, {'Content-Type' => 'text/html'}, ["<pre><b>#{e.message.gsub("<","&lt;")}</b>\n#{e.backtrace.join("\n")}</pre>"]]
      end
    end
  end
end
