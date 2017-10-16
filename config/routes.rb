Rails.application.routes.draw do
  root 'static#home'
  get '/auth/:provider/callback' => 'sessions#create_from_omni_auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :projects
  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
  resource :session,
    only: [:create]
end
