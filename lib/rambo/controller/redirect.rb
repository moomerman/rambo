module Redirect
  def redirect(destination, options={})
    destination = destination.to_s if destination.is_a? Symbol
    unless destination[0,1] == "/"
      destination = "/#{self.controller}/#{destination}"
    end
    #puts "redirecting to #{destination}"

    response.status = 302
    response.header['Location'] = destination
    return ""
  end
end