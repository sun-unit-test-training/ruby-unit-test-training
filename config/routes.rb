Rails.application.routes.draw do
  root 'exercise_1#index'

  resources :exercise1, only: :index
  resources :exercise2, only: [:new, :create]
  resources :exercise9, only: :index
end
