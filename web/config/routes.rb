Rails.application.routes.draw do
    get "auth/start"
    get "auth/code"
    get "auth/verify"
    use_doorkeeper
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

    scope "auth" do
        get "/" => "auth#start"
        get "code" => "auth#code"
        post "verify" => "auth#verify"
    end
    resources :collections

    root "user#index"
    get "up" => "rails/health#show", :as => :rails_health_check
end
