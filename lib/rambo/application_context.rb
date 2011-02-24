module Rambo
  class ApplicationContext
    attr_accessor :application_name
    
    def initialize(application_name = nil)
      @application_name = application_name
      puts "rambo: initializing application: #{application_name || 'default'}"
      @prefix = "#{self.application_name}/" if self.application_name
      @prefix ||= ''
      load_classes
    end
    
    def load_classes
      Dir["#{@prefix}lib/*.rb"].each { |x| funkyload x }
      Dir["#{@prefix}controller/*.rb"].each { |x| funkyload x; }
      Dir["#{@prefix}model/*.rb"].each { |x| funkyload x }
      Dir["#{@prefix}*.rb"].each { |x| funkyload x unless x == 'Rakefile.rb' }
    end
    
    def reload
      load_classes
    end
    
    def view_path
      "./#{@prefix}view"
    end
    
    private
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
            puts "rambo: loading: #{file}"
            load file
            @@loadcache[file] = File.mtime(file)
          end
        rescue Exception => e
          puts "Exception loading class [#{file}]: #{e.message}"
          puts e.backtrace.join("\n")
          raise e
        end
      end
    
  end
end