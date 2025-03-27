Rails.application.routes.draw do
  get "themes/show"
  get "tags/show"
  get "users/index"
  get "recommendation/index"
  get 'search', to: 'search#index'
  resources :profiles

  devise_for :users

  namespace :api, format: "json" do
    namespace :v1 do
      resources :podcasts, only: [:index, :show] do
        resources :issues, only: [:index, :show]  # Вложенные маршруты
      end
  
      resources :posts, only: [:index, :show, :create]
      resources :authors, only: [:index, :show]
      resources :themes, only: [:index, :show]
      resources :users, only: [:index, :show]
      resources :profiles, only: [:index, :show]
  
      devise_scope :user do 
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
        post "sign_out", to: "sessions#destroy"
      end
    end
  end

  namespace :admin do
    resources :issues do
    member do
      get 'toggle_favorite', to: 'favorites#toggle'
    end
  end
    resources :podcasts do 
      resources :issues 
      get 'issues', to: 'issues#issues_for_podcast', as: 'issues_for'
    end
    resources :profiles
    resources :posts do
      resources :comments, only: [:new, :create, :edit, :update, :destroy]
      member do
        get "like"
        get "dislike"
      end
    end
  end

  get "about_us/index"
  get "main/index"
  get "main/test"
  get "main/favorite"
  get "promo/index"
  get "recommendation", to: "recommendation#index"
  get 'main/favorite', to: 'favorites#index'

  resources :playlists do
    member do
      get 'add_issue/:issue_id', to: 'playlists#add_issue', as: :add_issue
      get 'remove_issue/:issue_id', to: 'playlists#remove_issue', as: :remove_issue
    end
  end
  resources :reviews, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  get 'user_playlists', to: 'playlists#user_playlists'

  resources :favorites, only: [:show, :index] do
    post :toggle, on: :collection
  end
  resources :themes
  resources :issues do
    resources :comments, only: [:new, :create, :edit, :update, :destroy, :show]
    member do
      get "like"
      get "dislike"
    end
    member do
      get 'toggle_favorite', to: 'favorites#toggle'
    end
  end
  resources :users
  get 'my_profile', to: 'users#profile', as: :my_profile
  resources :subscriptions, only: [:create]
  resources :podcasts do 
    member do
      get 'toggle_favorite', to: 'favorites#toggle'
    end

    resources :reviews, only: %i[new create edit update destroy show]
    resources :issues, only: [:index, :show]
    resources :posts
    get 'issues', to: 'issues#issues_for_podcast', as: 'issues_for'
  end

  resources :comments do
    member do
      get "like"
      get "dislike"
    end
  end

  resources :posts do
    collection do
      get :select_podcast_and_issue
      post :create_post_step
    end
    member do
      get "like"
      get "dislike"
    end
    resources :comments, only: [:new, :create, :edit, :update, :destroy, :show]
  end

  resources :tags  
  resources :authors
  resources :subscriptions

  # Маршруты для PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Корневой маршрут
  root "main#index"
end