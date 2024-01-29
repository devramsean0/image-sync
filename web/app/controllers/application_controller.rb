class ApplicationController < ActionController::Base
    include Authenticatable
    before_action :authenticate_user!
    skip_forgery_protection if Rails.env.development?
end
