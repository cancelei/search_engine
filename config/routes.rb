# Rails.application.routes.draw do
#   devise_for :users, controllers: {
#     registrations: 'users/registrations',
#     sessions: 'users/sessions',
#     passwords: 'users/passwords',
#     confirmations: 'users/confirmations',
#     unlocks: 'users/unlocks'
#   },
#   views: {
#     registrations: 'users/registrations',
#     sessions: 'users/sessions',
#     passwords: 'users/passwords',
#     confirmations: 'users/confirmations',
#     unlocks: 'users/unlocks'
#   }

#   get 'search/index'

#   # Define root path
#   root to: 'home#index'

#   # Define search route
#   get 'search', to: 'search#index'

#   # Define dashboard route for viewing search history
#   get 'users/dashboard', to: 'dashboard#index', as: 'user_dashboard'

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

# config/routes.rb

Rails.application.routes.draw do
  namespace :api do
    resources :search_histories, only: [:index]
  end
end
