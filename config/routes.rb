Rails.application.routes.draw do
  get "themes/show"
  get "tags/show"
  get "users/index"
  get "recommendation/index"
  resources :authors
  resources :profiles

  namespace :api, format: "json" do
    namespace :v1 do
      resources :posts, only: [:index, :show, :create]
      resources :authors, only: [:index, :show]
      resources :issues, only: [:index, :show]
      resources :podcasts, only: [:index, :show]
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
  


  devise_for :users
  get "about_us/index"
  get "main/index"
   get "main/test"
  get "promo/index"
  get 'recommendation', to: 'recommendation#index'
  resources :themes

  resources :issues
  resources :users
  get 'my_profile', to: 'users#profile', as: :my_profile

  resources :subscriptions, only: [:create]
  resources :podcasts do 
    resources :issues, only: [:index, :show]
    resources :posts
    get 'issues', to: 'issues#issues_for_podcast', as: 'issues_for'
  end

  resources :comments do
    member do
      post 'like'
      post 'dislike'
    end
  end


  resources :posts do
    resources :comments do
      member do
        post 'like'
        post 'dislike'
      end
    end
  end
  
  resources :issues do
    resources :comments do
      member do
        post 'like'
        post 'dislike'
      end
    end
  end

  resources :posts do
    collection do
      get :select_podcast_and_issue
      post :create_post_step
    end
    member do
      get "like"
    end
  end
  resources :tags  
  resources :posts do
    member do
      post :like
    end
  end
  
  namespace :admin do
    resources :issues do

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
      end
    end
  resources :authors
  resources :subscriptions
  resources :issue do 
    resources :comments
  end

  resources :posts do
    resources :comments
  end
  resources :tags  
end
devise_scope :user do
  delete '/users/sign_out', to: 'devise/sessions#destroy'
end

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "main#index"
end
