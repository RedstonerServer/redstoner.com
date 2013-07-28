Site::Application.routes.draw do

  resources :blogposts, :path => '/blog' do
    resources :comments
  end
  resources :users do
    member do
      get 'become'
    end
    collection do
      get 'unbecome'
    end
  end

  match '/serverstatus.png' => 'serverchecker#show'

  get "logout" => 'sessions#destroy'
  get 'login' => 'sessions#new'
  get 'register' => 'users#new'
  post 'login' => 'sessions#create'

  post 'paypal' => 'paypal#create'


  root :to => 'blogposts#index'
end