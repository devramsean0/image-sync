module Authenticatable
    extend ActiveSupport::Concern

    included { helper_method :user_signed_in?, :current_user }

    def authenticate_user!
        redirect_to auth_start_path unless user_signed_in?
    end

    def user_signed_in?
        current_user.present?
    end

    def current_user
        @current_user ||= lookup_user_by_cookie
    end

    private

    def lookup_user_by_cookie
        user_session = UserSession.find_by(cookie: session[:auth_cookie])
        if user_session.present? && user_session.authenticated
            user_session.user
        else
            nil
        end
    end
end
