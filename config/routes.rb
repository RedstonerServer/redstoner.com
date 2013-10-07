Site::Application.routes.draw do

  resources :blogposts, :path => '/blog' do
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
  resources :forumgroups, :path => '/forums' do
    member do
      resources :forums, :path => 'f' do
        member do
          resources :forumthreads, :path => 't', :as => 'threads' do
          end
        end
      end
    end
  end

  match '/status' => 'status#show'

  get "logout" => 'sessions#destroy'
  get 'login' => 'sessions#new'
  get 'signup' => 'users#new'
  post 'login' => 'sessions#create'

  post 'paypal' => 'paypal#create'

  root :to => 'blogposts#index'
end