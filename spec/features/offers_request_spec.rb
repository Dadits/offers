require 'rails_helper'

describe "offers request" do
  
  before do
    visit root_path
    @params = { uid: 'user1', pub0: 'custom parameter', page: 1 }
    @data = build(:offers_request).params.merge!(@params).to_query
  end

  it 'shows requested offer' do
    fake_request(request_data: @data, status: 200, headers: valid_header, body: offers_example_data)
    fill_in_form_with(@params)
    click_on I18n.t(:get_offers)
    expect(page).to have_content 'Tap Fish'
    expect(page).to have_css "img[src*='#{offers_example_data['offers'].first['thumbnail']['lowres']}']"
    expect(page).to have_css ".alert.alert-success.alert-dismissible.fade.in"
    expect(page).to have_content I18n.t(:successful_request)
  end
  
  it 'shows no offers' do
    fake_request(request_data: @data, status: 200, headers: empty_offers_header, body: no_offers_example_data)
    fill_in_form_with(@params)
    click_on I18n.t(:get_offers)
    expect(page).to have_content I18n.t(:no_offers)
    expect(page).to have_content I18n.t(:successful_request)    
  end
  
  it 'errors invalid params' do
    fake_request(request_data: @data, status: 200, headers: valid_header, body: offers_example_data)
    click_on I18n.t(:get_offers)
    expect(page).to have_content 'can\'t be blank'
    expect(page).to have_content 'is not a number'
  end

  it 'errors if invalid response' do
    fake_request(request_data: @data, status: 401, headers: valid_header, body: offers_example_bad_data)
    fill_in_form_with(@params)
    click_on I18n.t(:get_offers)
    expect(page).to have_content I18n.t(:invalid_response)
    expect(page).to have_content I18n.t(:invalid_hkey)
  end
  
end
