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
  resource :angular_root, :only => [:show]
  get '/templates/:path' => 'templates#template', :constraints => { :path => /.+/  }
 
  devise_scope :user do
    get '/current-user' => 'users/sessions#get_current_user'
    post '/login' => 'users/sessions#create'
    post '/logout' => 'users/sessions#destroy'
  end
  devise_for :user
  root :to => 'angular_root#show'
end
