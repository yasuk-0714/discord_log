Rails.application.routes.draw do
  root to: 'home#index'
  get 'mypage', to: 'home#mypage'
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
end
