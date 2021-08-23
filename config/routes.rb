Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  root to: 'questions#index'

  resources :questions, only: %i[new create show destroy] do
    resources :answers, shallow: true, only: %i[create show destroy]
  end
end
