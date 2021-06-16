Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      post "oauth/callback", to: "oauths#callback"
      get "oauth/callback", to: "oauths#callback"
      get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
      delete 'logout', to: 'user_sessions#destroy'
    end
  end
end
