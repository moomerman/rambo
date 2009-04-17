load 'rambo/templating.rb'

module Rambo
  class BaseController
    include Templating
  
    attr_accessor :params, :request, :response

    def params
      if !self.request.params.keys.join.include?('[')
        @params ||= indifferent_hash.merge(self.request.params)
      else
        @params ||= self.request.params.inject indifferent_hash do |res, (key,val)|
          if key.include?('[')
            head = key.split(/[\]\[]+/)
            last = head.pop
            head.inject(res){ |hash,k| hash[k] ||= indifferent_hash }[last] = val
          else
            res[key] = val
          end
          res
        end
      end
      if request.path_components.size() > 2
        @params.merge!(:id => request.path_components[3])
      end
      @params
    end
  
    def fresh?(model, options={})
      @@etags ||= {}
      etag = Digest::SHA1.hexdigest(model.inspect)
      response.header['ETag'] = "\"#{etag}\""
      response.header['Expires'] = (MooTime.now + options[:expires_in]).httpdate if options[:expires_in]
      response.header['Cache-Control'] = 'public'
      if @@etags[request.uri] == etag
        response.status = 304
        response.body = ''
        return true
      else
        @@etags[request.uri] = etag
        return false
      end
    end
  
    def controller
      self.request.controller
    end
  
    def action
      self.request.action
    end
  
    def indifferent_hash
      Hash.new {|hash,key| hash[key.to_s] if Symbol === key }
    end
  
    def redirect(destination, options={})
      destination = destination.to_s if destination.is_a? Symbol
      unless destination[0,1] == "/"
        destination = "/#{self.controller}/#{destination}"
      end
      puts "redirecting to #{destination}"
    
      response.status = 302
      response.header['Location'] = destination
      return ""
    end
  
  end
end