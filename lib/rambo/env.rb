# Env handles all the configuration loading, database initialization and class (re)loading
# would be nice to allow the user to specify their own init though if they want
# Env.new can be called anywhere in any application and therefore acts as a global config
module Rambo
  class Env
    def self.config
      @@config ||= YAML.load_file("rambo.yml") rescue nil
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
      
    end
    
  end
end