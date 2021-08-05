Rails.application.routes.draw do
  root to: 'home#index'
  get 'mypage', to: 'home#mypage'
  get 'privacy_policy', to: 'home#privacy_policy'
  get 'terms_of_service', to: 'home#terms_of_service'
  resources :guilds, param: :uuid, only: %i[show]
  resources :channels, param: :uuid, only: %i[show]

  namespace :api do
    namespace :v1 do
      post "oauth/callback", to: "oauths#callback"
      get "oauth/callback", to: "oauths#callback"
      get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
      delete 'logout', to: 'user_sessions#destroy'
      post 'times', to: 'channel_times#create'
    end
  end

  namespace :admin do
    root to: 'dashboards#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :users, only: %i[index edit update destroy]
    resources :users, param: :uuid, only: %i[show]
    resources :guilds, param: :uuid, only: %i[index show destroy] do
      resources :channels, only: %i[destroy], shallow: true
    end
  end
end
