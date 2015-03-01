Rails.application.routes.draw do
  root "static_pages#landing"

  get "*rest" => "static_pages#not_found"
end
