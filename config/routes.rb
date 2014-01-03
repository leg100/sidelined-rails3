SidelinedRails3::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  #

  namespace :api do
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
    resources :injuries
    resources :fixtures
    resources :history_trackers
   
    devise_scope :user do
      get '/current-user' => 'users/sessions#get_current_user'
      post '/login' => 'users/sessions#create'
      post '/logout' => 'users/sessions#destroy'
    end
  end

  get '/templates/:path' => 'templates#template', :constraints => { :path => /.+/  }
  resource :angular_root, :only => [:show]

  devise_for :user

  # send everything else to angular app
  match '*pages' => 'angular_root#show'
  root to: 'angular_root#show'
end
