Site::Application.routes.draw do

  resources :blogposts do
    resources :comments
  end
  resources :users

  match '/serverstatus.png' => 'serverchecker#show'
  get "logout" => 'sessions#destroy'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  post 'paypal' => 'paypal#create'
  root :to => 'blogposts#index'
end