Rails.application.routes.draw do
    use_doorkeeper_device_authorization_grant
    use_doorkeeper
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

    scope "auth" do
        get "start" => "auth#start", :as => :auth_start
        get "code" => "auth#code", :as => :auth_code
        post "verify" => "auth#verify", :as => :auth_verify
    end
    resources :collections

    root "user#index"
    get "up" => "rails/health#show", :as => :rails_health_check
end
