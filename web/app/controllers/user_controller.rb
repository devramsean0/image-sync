class UserController < ApplicationController
    def index
        @collections = current_user.collections
    end
end
