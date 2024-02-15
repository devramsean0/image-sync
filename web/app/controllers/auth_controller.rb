class AuthController < ApplicationController
    skip_before_action :authenticate_user!
    def start
        render layout: "auth"
    end

    def code
        user = User.find_by(email: params[:email])
        if user.nil?
            filtered_params = params.permit(:email, :first_name, :last_name)
            user =
                User.create!(
                    email: filtered_params[:email],
                    first_name: filtered_params[:first_name],
                    last_name: filtered_params[:last_name]
                )
        end
        user_session = UserSession.generate(user)
        cookies.encrypted[:auth_cookie] = { value: user_session.cookie, expires: 1.month.from_now }
        AuthMailer.auth_code(user, user_session.email_code).deliver_later
        render layout: "auth"
    rescue ActiveRecord::RecordInvalid => e
        @show_additional_fields = true
        render :start, layout: "auth"
    end

    def verify
        user_session = UserSession.find_by(cookie: cookies.encrypted[:auth_cookie])
        if user_session.present?
            if (params[:code].present? && user_session.email_code == params[:code])
                user_session.update(authenticated: true)
                redirect_to root_path, alert: "You are now logged in"
            else
                redirect_to auth_start_path, alert: "Invalid code, please try again"
            end
        else
            redirect_to auth_start_path, alert: "Invalid session, please try again"
        end
    end
end
