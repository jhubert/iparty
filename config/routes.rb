IParty::Application.routes.draw do
  resources :events

  match "/events" => "events#index", :as => "user_root"

  get "general/about"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'general#index'

end
