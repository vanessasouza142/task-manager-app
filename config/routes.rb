Rails.application.routes.draw do
  root to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'register', to: 'authentication#new'
  post 'register', to: 'authentication#create'

  resources :tasks do
    collection do
      post 'run_scraping'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :tasks, only: [] do
        collection do
          post 'update'
        end
      end
    end
  end
  
end
