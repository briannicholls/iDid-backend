Rails.application.routes.draw do
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

      # Session
      post 'login' => 'sessions#create'
      get 'current_user' => 'sessions#current_user'
      delete 'logout' => 'sessions#destroy'

      get 'state' => 'sessions#app_state'
      post 'state' => 'sessions#set_state'

      get 'users/:id/actions' => 'actions#index'
    end
  end
end
