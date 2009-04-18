module Cache
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
end