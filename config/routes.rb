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
      member do
        post :revert
      end
    end
    resources :clubs
    resources :events

    get '/injuries/current'
    resources :injuries do
      member do
        post :revert
      end
    end
    resources :fixtures
    resources :history_trackers

    post 'help/send_message' => 'help#send_message'

    get 'check-availability' => 'unique#check_availability'
   
    devise_scope :user do
      get 'current-user' => 'users/sessions#get_current_user'

      post 'users/sign_up' => 'users/registrations#create'
      post 'users/sign_in' => 'users/sessions#create'
      post 'users/sign_out' => 'users/sessions#destroy'
      get 'users/confirmation' => 'users/confirmations#show'
    end
  end

  devise_for :user, :controllers => {
    :registrations => "api/users/registrations",
    :sessions => "api/users/sessions",
    :confirmations => "api/users/confirmations" 
  }

  match "api" => proc { [404, {}, ['Invalid API endpoint']] }
  match "api/*path" => proc { [404, {}, ['Invalid API endpoint']] }

  # send paths handled by ui-router to angular app
  resource :angular_root, :only => [:show]
  match 'players' => 'angular_root#show'
  match 'players/*ids' => 'angular_root#show'
  match 'injuries' => 'angular_root#show'
  match 'injuries/*ids' => 'angular_root#show'
  match 'signup' => 'angular_root#show'
  match 'confirmed' => 'angular_root#show'
  match 'help' => 'angular_root#show'
  root to: 'angular_root#show'

  # the rest receive a 404.html
end
