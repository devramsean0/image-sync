class ApplicationController < ActionController::Base
    include Authenticatable
    before_action :authenticate_user!
end
