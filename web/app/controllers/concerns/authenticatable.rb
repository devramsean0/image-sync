module Authenticatable
    extend ActiveSupport::Concern

    included { helper_method :user_signed_in?, :current_user }

    def authenticate_user!
        redirect_to auth_path unless user_signed_in?
    end

    def user_signed_in?
        current_user.present?
    end

    def current_user
        @current_user ||= lookup_user_by_cookie
    end

    private

    def lookup_user_by_cookie
        User.find(session[:user_id]) if session[:user_id]
    end
end
