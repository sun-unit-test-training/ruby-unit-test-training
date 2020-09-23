Rails.application.routes.draw do
  root 'exercise_1#index'

  resources :exercise1, only: :index
  resources :exercise2, only: [:new, :create]
  resources :exercise3, only: :index
  resources :exercise4, only: :index
  resources :exercise5, only: :index
  resources :exercise7, only: :index
  resources :exercise8, only: :index
  resources :exercise9, only: :index

  get "/exercise6", to: "exercise6#free_parking_time"
  post "/exercise6", to: "exercise6#calculate_free_parking_time"
  get "exercise10/checkout" => "exercise10#checkout"
  post "exercise10/checkout" => "exercise10#checkout"
end
