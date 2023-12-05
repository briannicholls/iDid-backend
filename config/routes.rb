Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }, defaults: { format: :json }

  # Use devise passwords controller for password reset redirect
  devise_scope :user do
    # Deep link to app
    get 'password_redirect_to_app/:token', to: 'users/passwords#redirect_to_app', as: :password_redirect_to_app
  end

  namespace :api do
    namespace :v1 do
      resources :routines
      resources :actions
      resources :counters
      resources :users do
        resources :actions
      end
      resources :units_of_measure

      get 'leaders' => 'counters#leaders'

      # Session
      post 'login'       => 'sessions#create'
      get 'current_user' => 'sessions#fetch_current_user'
      delete 'logout'    => 'sessions#destroy'
      post 'password'    => 'sessions#reset_password'
      
      # Obsolete
      # get 'state' => 'sessions#app_state'
      # post 'state' => 'sessions#set_state'
      
      get 'users/:id/actions' => 'actions#index'

    end
  end
end
