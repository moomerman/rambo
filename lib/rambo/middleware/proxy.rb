require 'net/http'
require 'right_http_connection'

module Rack
  class Proxy
    def initialize(app, options={})
      @app = app
      @options = options
      @@conn = Rightscale::HttpConnection.new
    end

    def call(env)
      
      request = Request.new(env)
      
      # tey out persistent connections using right http conn (need to make params aware?)
      
      begin
        
        backend = rand(@options[:backend].size+1)
        
        if backend == @options[:backend].size
          @app.call(env)
        else
          host = URI.parse("http://#{env['HTTP_HOST']}").host
          port = @options[:backend][backend]
      
          req = Net::HTTP::Get.new(env['REQUEST_URI'])
          res = Net::HTTP.start(host, port) {|http|
             http.request(req, request.params)
           }

          # need to be able to pass params into request below
          #res = @@conn.req(:server => host, :port => port, :protocol => 'http', :request => request)
        
          body = res.body || ''
        
          [res.code.to_i, {'ETag' => res['ETag'], 'Cache-Control' => res['Cache-Control'], 'Content-Type' => res['Content-Type'], 'Location' => res['Location']}, body]
        end
      rescue Exception => e
        puts e.message
        @app.call(env)
      end
    end
    
  end
end

