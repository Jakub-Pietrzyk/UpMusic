Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }, path_prefix: 'my'
  resources :users do
    resources :observations
    resources :idols
    delete 'notifications_del' => 'notifications#destroy_all', as: "destroy_all_notifications"
    member do
      post :add_sm
      post :change_background
      get :show
    end
  end

  devise_scope :user do
    root 'devise/sessions#new', as: "log"
  end

  resources :musics do
    resources :upvotes
    resources :comments

    collection do
      get :show_by_genre
      get :hall_of_fame
    end
  end

  resources :posts do
    collection do
      get :super_posts
    end
  end
  resources :notifications

  get 'dashboard' => "main#dashboard", as: "home"

  get "search" => "main#search", as: "search"

  resources :chatrooms do
    resources :messages
  end

  mount ActionCable.server => '/cable'

end
