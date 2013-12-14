SidelinedRails3::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  #

  resources :players do
    collection do
      get :typeahead
      get :namecheck
      get :tickergen
      post :search
    end
  end
  resources :clubs
  resources :events
  resources :fixtures

  root :to => 'events#index'

  devise_for :users
end
