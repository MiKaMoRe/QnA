Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  root to: 'questions#index'

  resources :questions, only: %i[new create show destroy update] do
    resources :answers, shallow: true, only: %i[create show destroy update] do
      member do
        patch :nominate
        put :vote, voteable_type: 'Answer'
        delete :cancel_vote, voteable_type: 'Answer'
      end
      
      resources :files, shallow: true, only: %i[] do
        delete :answer_destroy
      end
    end

    member do
      put :vote, voteable_type: 'Question'
      delete :cancel_vote, voteable_type: 'Question'
    end

    resources :files, shallow: true, only: %i[] do
      delete :question_destroy
    end
  end

  resources :answers, only: %i[] do
    resources :comments, shallow: true, defaults: { commentable_type: 'Answer' }, only: %i[create destroy]
  end

  resources :questions, only: %i[] do
    resources :comments, shallow: true, defaults: { commentable_type: 'Question' }, only: %i[create destroy]
  end

  resources :rewards, only: %i[index]
  resources :links, only: %i[destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: %i[index create show destroy update] do
        resources :answers, shallow: true, only: %i[create show destroy update]
      end
    end
  end
end
