Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  get 'search/index'

  # Define root path
  root to: 'search#index'

  # Define search route
  get 'search', to: 'search#index'

  # Define dashboard route for viewing search history
  get 'users/dashboard', to: 'dashboard#index', as: 'user_dashboard'

  # Defines the root path route ("/")
  # root "posts#index"
end
