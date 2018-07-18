Rails.application.routes.draw do
  resources :lectures do
    resources :questions, shallow: true
  end

  devise_for :users
  root to: 'application#home'
end
