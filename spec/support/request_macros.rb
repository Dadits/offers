module ResponseMacros
  require 'digest/sha1'
  
  def fake_request(params = {})
    stub_request(:get, "api.sponsorpay.com/feed/v1/offers.json?#{ params[:request_data] }").to_return(
      {
           body: params[:body].to_json,
        headers: params[:headers],
         status: params[:status]
      })
  end
  
  def offers_example_data
    { 'offers' =>
      [{ 
        'title' => 'Tap Fish', 
        'thumbnail' => { 'lowres' => 'http://static3.businessinsider.com/image/51c3211b69bedd8843000023-480/black-hole.jpg' }, 
        'payout' => '90'
      }]
    }
  end

  def offers_example_bad_data
    offers_example_data.merge!('message' => I18n.t(:invalid_hkey))
  end

  
  def valid_header
    { 'X-Sponsorpay-Response-Signature' => Digest::SHA1.hexdigest(offers_example_data.to_json + Rails.application.secrets.fyber_api_key)}
  end
  
  def valid_hash_key(request)
    Digest::SHA1.hexdigest(request.params.except(:hashkey).to_query + "&#{ Rails.application.secrets.fyber_api_key }")
  end
  
end