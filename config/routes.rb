Rails.application.routes.draw do
  devise_for :users
  
  root to: 'questions#index'

  resources :questions, only: %i[create show] do
    resources :answers, only: %i[create show]
  end
end
