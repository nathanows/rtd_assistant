Rails.application.routes.draw do
  match ':status', to: 'errors#show', via: :all, constraints: { status: /\d{3} }/ }

  root "static_pages#landing"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get "/dashboard"         => "dashboard#index"
  post "/new_phone_number" => "phone_numbers#create"
  post "/new_location"     => "locations#create"
  post "/new_notification" => "notifications#create"
  get "/receive_text"      => "notifications#receive_text"

  #get "*rest" => "static_pages#not_found"
end
