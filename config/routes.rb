Redstoner::Application.routes.draw do

  resources :blogposts, path: '/blog' do
    resources :comments
  end

  resources :statics, only: [:home, :donate], path: '/' do
    collection do
      get 'donate'
      get 'home'
      get 'index'
    end
  end

  resources :info

  resources :users do
    member do
      get 'confirm'
      get 'edit_login'
      post 'resend_mail'
      get 'edit_notifications'
      put 'update_login'
    end
    collection do
      get  'lost_password'
      post 'reset_password'
      post 'suggestions'
    end
  end

  resources :forumgroups,  path: '/forums/groups'
  resources :forums,       path: '/forums'
  resources :forumthreads, path: '/forums/threads' do
    resources :threadreplies, path: 'replies'
  end

  resources :tools do
    collection do
      post 'render_markdown'
    end
  end

  # get '/status' => 'status#show'

  get  'login'  => 'sessions#new'
  post 'login'  => 'sessions#create'
  get  'become' => 'sessions#become'
  get  'revert' => 'sessions#revert'
  delete  'logout' => 'sessions#destroy'
  get  'signup' => 'users#new'
  get  '/dmca'  => redirect('https://www.youtube.com/watch?v=oHg5SJYRHA0')

  root to: 'statics#index'
end
