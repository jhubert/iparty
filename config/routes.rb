IParty::Application.routes.draw do

  get "guest" => "guest#index"
  get "guest/party/:id" => "guest#party", :as => :guest_party
  get "guest/payment/:id" => "guest#payment", :as => :guest_payment
  post "guest/charge/:id" => "guest#charge", :as => :guest_charge
  get "guest/thanks/:id" => "guest#thanks", :as => :guest_thanks

  resources :events do
    member do
      post :update_donation_amount
    end
  end

  # Path for devise redirection
  # match "/events" => "events#index", :as => "user_root"

  get "general/about"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'general#index'

end
