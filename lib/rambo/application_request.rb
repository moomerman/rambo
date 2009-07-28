module Rambo
  class ApplicationRequest < Rambo::Request
    
    def initialize(env)
      super
    end
    
    def application
      path_components[1]
    end
    
    def controller
      path_components[2] || default_controller
    end
  
    def action
      path_components[3] || 'index'
    end
    
    def controller_class
      self.application.gsub(/^[a-z]|\s+[a-z]/) { |a| a.upcase } + '::' + super
    end
    
  end
end