class UserController < ApplicationController
    skip_before_action :authenticate_user!, only: :index
    def index
        redirect_to auth_path unless user_signed_in?
    end
end
