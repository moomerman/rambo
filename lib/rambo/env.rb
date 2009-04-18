module Rambo
  class Env
    @@config = {}
    
    def initialize
      # TODO: config reload
      @@config ||= YAML.load_file("config.yml") rescue nil || {}
      
      if dbconf = @@config['datamapper']
        require 'dm-core'
        require 'dm-validations'
        require 'dm-timestamps'
        #DataMapper.setup(:default, 'mysql://localhost/moo_development')
        @@connection ||= DataMapper.setup(
          :default,
          :adapter => :mysql, 
          :host => dbconf['host'], 
          :database => dbconf['database'], 
          :username => dbconf['username'], 
          :password => dbconf['password']
        )
        @@dblogger ||= DataObjects::Mysql.logger = DataObjects::Logger.new(STDOUT, dbconf['logging']) if dbconf['logging']
      end
      
      Dir["controller/*.rb"].each { |x| funkyload x }
      Dir["model/*.rb"].each { |x| funkyload x }
      Dir["lib/*.rb"].each { |x| funkyload x }
    end
    
    private
      # turn this into a thread that checks every x seconds
      # (any chance of a callback?) so it is outside of the 
      # request/response cycle
      def funkyload(file)
        @@loadcache ||= {}
        if cache = @@loadcache[file]
          return unless @@config['rambo']['reload_classes']
          if (mtime = File.mtime(file)) > cache
            puts "rambo: reloading: #{file}"
            load file
            @@loadcache[file] = mtime
          end
        else
          #puts "loading: #{file}"
          load file
          @@loadcache[file] = File.mtime(file)
        end
      end
    
  end
end