class Api::V1::UserController < ApplicationController
    skip_before_action :authenticate_user!
    before_action -> { doorkeeper_authorize! :image_read }
    def index
        render json: {
            hello: "world"
        }.to_json
    end

    private

    def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
end
