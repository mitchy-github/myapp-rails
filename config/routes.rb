Rails.application.routes.draw do
  resources :questions do
    resources :question_answers, only: [:create, :destroy, :edit, :update]
  end

  resources :categories, only: [:index, :show] #hashtagsコントローラー作成後記入

  root 'sessions#index'

  post "/guest_login", to: "guest_sessions#create"

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  # get '/users/:id', to: 'users#show'
  # delete '/users/:id', to: 'users#destroy'
  resources :users, only: %i(show destroy edit update)
  # 上記の()にupdateを追加するとうまくロールバックせずアップデートされた

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :sessions, only: %i(index)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resources :sessions
end
