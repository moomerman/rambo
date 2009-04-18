module Rack
  class Upload
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      
      #puts "UPLOAD SAYS HELLO"
      
      @app.call(env)
    end
  end
end

