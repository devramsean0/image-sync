Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  scope "user" do
    get "login", to: "user#login", as: :user_login
    post "send_code", to: "user#send_code", as: :user_auth_send_code
    get "authenticate/:token", to: "user#authenticate", as: :user_auth_authenticate
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # root "posts#index"
end
