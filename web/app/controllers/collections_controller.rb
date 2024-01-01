class CollectionsController < ApplicationController
    def index
        @collections = current_user.collections
    end
    def new; end
    def create
        collection = current_user.collections.create(params.permit(:name, :public))
        if collection
            flash[:notice] = "Collection created"
            redirect_to collections_path
        else
            flash[:error] = "Failed to create collection"
            redirect_to new_collection_path
        end
    end
    def show
        @collection = current_user.collections.find(params[:id])
    end
    def edit
        @collection = current_user.collections.find(params[:id])
    end
    def update
        collection = current_user.collections.find(params[:id])
        if collection.update(params.permit(:name, :public))
            redirect_to collections_path, notice: "Collection updated"
        else
            redirect_to edit_collection_path(collection), notice: "Failed to update collection"
        end
    end
    def destroy
        collection = current_user.collections.delete(params[:id])
        if collection
            redirect_to collections_path, notice: "Collection deleted"
        else
            redirect_to collections_path, notice: "Failed to delete collection"
        end
    end
end
