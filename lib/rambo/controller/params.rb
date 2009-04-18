module Params
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
  
  def indifferent_hash
    Hash.new {|hash,key| hash[key.to_s] if Symbol === key }
  end
end