require 'rails_helper'
require 'digest/sha1'

describe OffersRequest do
  let(:request) { build(:offers_request) }

  describe "validations" do

    it "is valid" do
      expect(request.valid?).to be_truthy
    end

    it "validates uid" do
      request.uid = ''
      expect(request.valid?).to be_falsey
    end
    
    it 'validates page' do
      request.page = ''
      expect(request.valid?).to be_falsey
      request.page = 0
      expect(request.valid?).to be_falsey      
    end

  end
  
  describe 'request' do
    
    it 'prepares and gathers request params, generates valid hashkey' do
      expect(request.params[:appid]).to eq 157
      expect(request.params[:hashkey]).to eq valid_hash_key(request)
    end
    
    describe 'get offers data' do
      
      it 'receives offers data using valid params' do
        fake_request(request_data: request.params.to_query, status: 200, headers: valid_header, body: offers_example_data)
        expect(request.get_offers_data).to eq offers_example_data
      end
      
      it 'sets and returns errors if invalid data been sent' do
        fake_request(request_data: request.params.to_query, status: 401, headers: valid_header, body: offers_example_bad_data)
        expect(request.get_offers_data).to eq request.errors
        expect(request.errors.messages[:request].first).to eq I18n.t(:invalid_hkey)
        expect(request.errors.messages[:response].first).to eq I18n.t(:invalid_response)
      end
      
    end
    
  end

end
