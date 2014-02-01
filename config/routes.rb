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

  resources :roles

  resources :users do
    member do
      get 'become'
      get 'confirm'
    end
    collection do
      get 'unbecome'
    end
  end

  resources :forums, path: 'forums' do
    resources :forumthreads, path: 'threads'
    collection do
      resources :forumgroups, path: 'groups'
    end
  end

  match '/status' => 'status#show'

  get "logout" => 'sessions#destroy'
  get 'login' => 'sessions#new'
  get 'signup' => 'users#new'
  post 'login' => 'sessions#create'

  post 'paypal' => 'paypal#create'

  root to: 'statics#index'
end