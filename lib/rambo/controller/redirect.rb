module Redirect
  def redirect(destination, options={})
    destination = destination.to_s if destination.is_a? Symbol
    unless destination[0,1] == "/" or destination =~ /^http(s)?:\/\// or destination =~ /^file:\/\//
      destination = "/#{self.controller}/#{destination}"
    end
    puts "redirect: ".cyan + "#{destination}"
    
    @rendered = true
    response.status = 302
    response.header['Location'] = destination
    return ""
  end
end