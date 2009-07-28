# Env handles all the configuration loading, database initialization and class (re)loading
# would be nice to allow the user to specify their own init though if they want
# Env.new can be called anywhere in any application and therefore acts as a global config
module Rambo
  class Env
    def self.config
      @@config ||= YAML.load_file("config.yml") rescue nil
      @@config ||= {}
    end
    
    def initialize
      begin
        # TODO: config reload
        
        if dbconf = Env.config['mongodb']
          require 'mongomapper'
          @@database ||= MongoMapper.database = dbconf['database']
        end
        
        if dbconf = Env.config['datamapper']
          require 'dm-core'
          require 'dm-validations'
          require 'dm-timestamps'
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
      rescue Exception => e
        puts "Exception initializing environment: #{e.message}"
        puts e.backtrace.join("\n")
        raise e
      end
      
      Dir["controller/*.rb"].each { |x| funkyload x }
      Dir["model/*.rb"].each { |x| funkyload x }
      Dir["lib/*.rb"].each { |x| funkyload x }
      Dir["*.rb"].each { |x| funkyload x unless x == 'Rakefile.rb' }
    end
    
    private
      # turn this into a thread that checks every x seconds
      # (any chance of a callback?) so it is outside of the 
      # request/response cycle
      def funkyload(file)
        @@loadcache ||= {}
        begin
          if cache = @@loadcache[file]
            return if Env.config['rambo'] and Env.config['rambo']['reload_classes'] == false
            if (mtime = File.mtime(file)) > cache
              puts "rambo: reloading: #{file}"
              load file
              @@loadcache[file] = mtime
            end
          else
            #puts "rambo: loading: #{file}"
            load file
            @@loadcache[file] = File.mtime(file)
          end
        rescue Exception => e
          puts "Exception loading class [#{file}]: #{e.message}"
          puts e.backtrace.join("\n")
        end
      end
    
  end
end