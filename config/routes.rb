Rails.application.routes.draw do
  root 'exercise_1#index'

  resources :exercise1, only: :index
  resources :exercise5, only: :index
  resources :exercise9, only: :index

  get "/exercise6", to: "exercise6#free_parking_time"
  post "/exercise6", to: "exercise6#calculate_free_parking_time"
end
