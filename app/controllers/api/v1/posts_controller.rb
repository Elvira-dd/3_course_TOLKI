class Api::V1::PostsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]

    def index
      @posts = Post.all
    end
  
    def show
      @post = Post.find(params[:id])
    end
  
  
    private
  
      def post_params
        params.require(:post).permit(:title, :description)
      end
  

end
