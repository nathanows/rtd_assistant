Rails.application.routes.draw do
  match ':status', to: 'errors#show', via: :all, constraints: { status: /\d{3} }/ }

  root "static_pages#landing"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get "/dashboard" => "dashboard#index"

  post "/notifications/notify" => "notifications#notify"
  post "/sms" => "receive_text#index"
  get "/sms" => "receive_text#index"

  #get "*rest" => "static_pages#not_found"
end
