Site::Application.routes.draw do

  resources :blogposts, path: '/blog' do
    resources :comments
  end

  resources :statics, only: [:index, :donate], path: '' do
    collection do
      get 'donate'
      get 'index'
    end
  end

  resources :info

  resources :users do
    member do
      get 'become'
      get 'confirm'
    end
    collection do
      get 'unbecome'
    end
  end

  resources :forumgroups, path: 'forums/groups'
  resources :forums, path: 'forums'
  resources :forumthreads, path: '/forums/threads' do
    resources :threadreplies, path: '/forums/threads/replies'
  end

  # get '/status' => 'status#show'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get "logout" => 'sessions#destroy'
  get 'signup' => 'users#new'

  # post 'paypal' => 'paypal#create'

  root to: 'statics#index'
end