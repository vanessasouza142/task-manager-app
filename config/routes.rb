Rails.application.routes.draw do
  root to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'register', to: 'authentication#new'
  post 'register', to: 'authentication#create'

  resources :tasks
end
