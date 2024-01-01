Rails.application.routes.draw do
  use_doorkeeper
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resource :auth, only: %i[show create destroy], controller: :auth
  resource :auth_verifications, only: %i[show create]
  resources :collections

  root "user#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
