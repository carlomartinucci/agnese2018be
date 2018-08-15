Rails.application.routes.draw do
  default_url_options host: Rails.application.config.default_url_host

  resources :answers, only: [:index, :show, :create, :update]
  resources :lectures, only: [:index, :new, :edit, :create, :update, :destroy] do
    resources :questions, shallow: true
  end
  post '/questions/:id/move/:where', to: 'questions#move', as: 'move_question'

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
  get 'googlefbd316a7a778fef4', to: 'application#googlefbd316a7a778fef4'
  get 'kaboom', to: 'application#kaboom'
  root to: 'application#home'
end
