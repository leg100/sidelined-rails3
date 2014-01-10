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
    resources :injuries do
      member do
        post :revert
      end
    end
    resources :fixtures
    resources :history_trackers
   
    devise_scope :user do
      get '/check-availability' => 'users/sessions#check_availability'
      get '/current-user' => 'users/sessions#get_current_user'
      post '/login' => 'users/sessions#create'
      post '/logout' => 'users/sessions#destroy'
      post '/signup' => 'users/registrations#create'
    end
  end

  devise_for :user

  match "api" => proc { [404, {}, ['Invalid API endpoint']] }
  match "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }

  # send paths handled by ui-router to angular app
  resource :angular_root, :only => [:show]
  match 'injuries' => 'angular_root#show'
  match 'injuries/*ids' => 'angular_root#show'
  root to: 'angular_root#show'

  # the rest receive a 404.html
end
