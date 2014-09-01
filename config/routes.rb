Rails.application.routes.draw do
  root 'offers#new'
  
  resources :offers, only: [:new] do
    post 'requested', on: :collection
  end
end