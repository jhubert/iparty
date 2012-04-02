IParty::Application.routes.draw do
  get "general/about"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'general#index'
end
