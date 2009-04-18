#!/usr/bin/env ruby

require 'rubygems'
require 'thin'

require 'rambo/env'
require 'rambo/controller'
require 'rambo/middleware'
require 'rambo/time'
require 'rambo/request'
require 'rambo/response'

module Rambo
  class Server
    
    def initialize(options = {})
      @options = options
    end
  
    def call(env)
      begin
        Rambo::Env.new
      
        request = Request.new(env)
        response = Response.new
      
        ctl_string = (request.controller.downcase.gsub(/^[a-z]|\s+[a-z]/) { |a| a.upcase } + 'Controller')
        begin
          obj = Object.module_eval("::#{ctl_string}", __FILE__, __LINE__).new
        rescue Exception => e
          return [404, response.header, "<h1>Controller #{ctl_string} Not Found</h1>"]
        end
        obj.request = request
        obj.response = response
      
        #begin
          result = obj.send(request.action)
        #rescue Exception => e
          #return [404, response.header, "<h1>Action #{request.action} Not Found</h1>"]
        #end
        response.body = result if result
      
        [response.status, response.header, response.body]
      rescue Exception => e
        puts e.message
        return [500, response.header, "<pre><b>#{e.message.gsub("<","&lt;")}</b>\n#{e.backtrace.join("\n")}</pre>"]
      end
    end
  end
end