class OffersController < ApplicationController
  
  def new
    @request = OffersRequest.new
  end
  
  def requested
    @request = OffersRequest.new(permitted_params.offers_request)
    if @request.valid?
      data = @request.get_offers_data
      return render 'new' if @request.errors.any?
      @offers = data['offers']
      flash.now[:notice] = data['message']
    else
      render 'new'
    end
  end
  
end