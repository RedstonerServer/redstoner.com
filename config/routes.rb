Site::Application.routes.draw do

  resources :blogposts, path: '/blog' do
    resources :comments
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

  resources :forums, path: 'forums', as: 'forums' do
      collection do
        resources :forumgroups, path: 'groups'
      end
      member do
        resources :forumthreads, path: 'threads'
      end
  end

  match '/status' => 'status#show'

  get "logout" => 'sessions#destroy'
  get 'login' => 'sessions#new'
  get 'signup' => 'users#new'
  post 'login' => 'sessions#create'

  post 'paypal' => 'paypal#create'

  root to: 'blogposts#index'
end