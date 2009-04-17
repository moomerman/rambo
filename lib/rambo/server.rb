#!/usr/bin/env ruby

require 'rubygems'
require 'thin'

require 'rambo/lock'
require 'rambo/proxy'
require 'rambo/templating'
require 'rambo/base_controller'
require 'rambo/time'
require 'rambo/upload'
require 'rambo/request'
require 'rambo/response'

module Rambo
  class Server
  
    def initialize(options = {})
      @options = options
      # load from config - only do this IF database required
      require 'dm-core'
      require 'dm-validations'
      require 'dm-timestamps'
      #DataMapper.setup(:default, 'mysql://localhost/moo_development')
      DataMapper.setup(:default, :adapter => :mysql, :host => 'localhost', :database => 'moo_development', :username => 'root', :password => '')
      #DataObjects::Mysql.logger = DataObjects::Logger.new(STDOUT, :debug)
    end
  
    def call(env)
      begin
        Dir["controller/*.rb"].each { |x| funkyload x }
        Dir["model/*.rb"].each { |x| funkyload x }
        Dir["lib/*.rb"].each { |x| funkyload x }
      
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
  
    private
      # turn this into a thread that checks every x seconds
      # (any chance of a callback?) so it is outside of the 
      # request/response cycle
      def funkyload(file)
        @@loadcache ||= {}
        if cache = @@loadcache[file] 
          if (mtime = File.mtime(file)) > cache
            puts "reloading: #{file}"
            load file
            @@loadcache[file] = mtime
          end
        else
          puts "loading: #{file}"
          load file
          @@loadcache[file] = File.mtime(file)
        end
      end
  end
end