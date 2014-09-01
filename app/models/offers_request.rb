class OffersRequest
  require 'digest/sha1'
  include ActiveModel::Model
  include ActiveModel::Validations
  include HTTParty
  
  attr_accessor :uid, :pub0, :page, :params
  
  validates_presence_of :uid
  validates :page, numericality: { greater_than: 0 }
  
  base_uri "api.sponsorpay.com/feed/v1"
    
  def get_offers_data
    response = self.class.get("/offers.json?#{ params.to_query }")
    body = JSON.parse(response.body)
    response_invalid?(response, body) ? errors : body
  end
    
  private
  
    def initialize(params = {})
      self.uid = params[:uid]
      self.page = params[:page]
      self.params = prepare_request_params(params)
    end  
  
    def prepare_request_params(params)
      gathered_params = gather_params(params)
      gathered_params.merge!(hashkey: generate_key(gathered_params.to_query, '&'))
    end
    
    def gather_params(params)
      params.merge!(
        appid: 157,
        format: 'json',
        ip: '109.235.143.113',
        locale: 'de',
        timestamp: Time.now.to_i,
        offer_types: 113,
        device_id: '2b6f0cc904d137be2e1730235f5664094b831186'
      )
    end
        
    def response_invalid?(response, body)
      errors.add(:request, body['message']) unless response.code == 200
      errors.add(:request, I18n.t(:invalid_response)) unless generate_key(response.body) == response.headers['X-Sponsorpay-Response-Signature']
      errors.any?
    end
    
    def generate_key(data, sign='')
      Digest::SHA1.hexdigest(data + "#{ sign }#{ Rails.application.secrets.fyber_api_key }")
    end
      
end