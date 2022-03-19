Rails.application.routes.draw do
  post 'api/v1/login' => 'api/v1/sessions#login'
  get 'api/v1/current_user' => 'api/v1/sessions#get_current_user'
  delete 'api/v1/logout' => 'api/v1/sessions#destroy'
  get 'api/v1/state' => 'api/v1/sessions#get_state'
  post 'api/v1/state' => 'api/v1/sessions#set_state'
  get '/api/v1/users/:id/actions' => 'api/v1/actions#index'

  devise_for :users, controllers: {confirmations: 'users/confirmations'}

  namespace :api do
    namespace :v1 do
      resources :routines
      resources :actions
      resources :counters
      resources :users do
        resources :actions
      end
      get 'leaders' => 'counters#leaders'
    end
  end
end
