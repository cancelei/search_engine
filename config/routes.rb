Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  },
  views: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  get 'search/index'
  get 'search/results'
  root 'search#index'

  # Define root path
  # root to: 'home#index'

  # Define search route

  # Define dashboard route for viewing search history
  get 'users/dashboard', to: 'dashboard#index', as: 'user_dashboard'

  # Defines the root path route ("/")
  # root "posts#index"
end
