class MooController < Rambo::BaseController
  def index
    "Moo Value of voo? #{params[:voo]}"
  end
  def carrot
    response.status = 404
    response.header['Content-Type'] = 'text/plain'
    "Not Found"
  end
  def xml
    response.header['Content-Type'] = 'application/xml'
    "<moo><foo/></moo>"
  end
  def slow
    sleep 0.5
    ""
  end
  def nothing
    @name = 'fred'
    erb :blegga
  end
end