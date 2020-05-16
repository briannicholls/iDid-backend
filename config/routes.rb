Rails.application.routes.draw do

  post 'api/v1/login' => 'api/v1/sessions#login'
  get 'api/v1/current_user' => 'api/v1/sessions#get_current_user'
  delete 'api/v1/logout' => 'api/v1/sessions#destroy'

  get 'state' => 'api/v1/sessions#get_state'
  post 'state' => 'api/v1/sessions#set_state'
  # root to: '/api/v1/'

  get '/api/v1/users/:id/actions' => 'api/v1/actions#index'

  namespace :api do
    namespace :v1 do

      get 'login' => 'sessions#new'
      resources :routines
      resources :actions
      resources :counters
      resources :users do
        resources :actions
      end

    end
  end
end
