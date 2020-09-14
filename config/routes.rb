Rails.application.routes.draw do
  root 'exercise_1#index'

  resources :exercise1, only: :index
end
