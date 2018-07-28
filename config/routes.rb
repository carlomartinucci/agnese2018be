Rails.application.routes.draw do
  default_url_options host: Rails.env.production? ? 'https://agnese2018be.herokuapp.com' : 'http://localhost:3000'

  resources :answers, only: [:index, :show, :create, :update]
  resources :lectures do
    resources :questions, shallow: true
  end

  namespace :api, format: :json do
    namespace :v1 do
      resources :lectures, only: [:index, :show]
      resources :questions, only: [:show]
      resources :answers, only: [:show] do
        member do
          put '/', to: 'answers#first_or_create'
        end
      end
    end
  end

  devise_for :users
  root to: 'application#home'
end
