FactoryGirl.define do
  factory :offers_request do
    uid 'user1'
    pub0 'custom parameter'
    page 1
    initialize_with { new(attributes) }
  end
end