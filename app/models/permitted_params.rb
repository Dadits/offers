class PermittedParams

  attr_reader :params

  def initialize(params)
    @params = params
  end
  
  def offers_request
    params.require(:offers_request).permit(:uid, :pub0, :page)
  end
  
end