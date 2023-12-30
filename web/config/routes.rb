Rails.application.routes.draw do
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # root "posts#index"

  resource :auth, only: %i[show create destroy], controller: :auth
  resource :auth_verifications, only: %i[show create]

  root "user#index"
end
