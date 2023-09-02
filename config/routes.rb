Rails.application.routes.draw do
  root 'sessions#index'

  post "posts/upload_image", to: "posts#upload_image"
  resources :posts, only: %i(index show new create update destroy edit update) do
    resource :favorites, only: [:create, :destroy]
  end

  resources :chats, only: [:show, :create]

  resources :categories, only: [:index, :show]
  resources :questions do
    resources :question_answers, only: [:create, :destroy, :edit, :update]
  end

  post "/guest_login", to: "guest_sessions#create"
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  resources :users, only:[:index, :show, :edit, :destroy, :update] do
    member do
      get :follows, :followers, :favorites
    end
    resource :relationships, only: [:create, :destroy]
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :sessions, only: %i(index)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resources :sessions
end
