module Rambo
  class Response < Rack::Response
    def initialize
      @status, @body = 200, []
      @header = Rack::Utils::HeaderHash.new({
        'Content-Type' => 'text/html',
        'Server' => 'Rambo <http://github.com/moomerman/rambo>'
      })
    end

    # def write(str)
    #   @body << str.to_s
    #   str
    # end
    #
    # def finish
    #   @body = block if block_given?
    #   if [204, 304].include?(status.to_i)
    #     header.delete "Content-Type"
    #     [status.to_i, header.to_hash, []]
    #   else
    #     body = @body || []
    #     body = [body] if body.respond_to? :to_str
    #     if body.respond_to?(:to_ary)
    #       header["Content-Length"] = body.to_ary.
    #         inject(0) { |len, part| len + part.bytesize }.to_s
    #     end
    #     [status.to_i, header.to_hash, body]
    #   end
    # end
  end
end