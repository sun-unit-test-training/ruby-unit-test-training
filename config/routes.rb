Rails.application.routes.draw do
  root 'exercise_1#index'

  resources :exercise1, only: :index
  resources :exercise2, only: [:new, :create]
  resources :exercise5, only: :index
  resources :exercise9, only: :index
<<<<<<< HEAD

  get "/exercise6", to: "exercise6#free_parking_time"
  post "/exercise6", to: "exercise6#calculate_free_parking_time"
=======
  resources :exercise3, only: :index
>>>>>>> Exercise 3 TDD Testing
end
