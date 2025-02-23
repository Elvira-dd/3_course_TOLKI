class Api::V1::PostsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]

    def index
      @posts = Post.all
    end
  
    def show
      @post = Post.find(params[:id])
    end
  
    def create
      user = User.find_by_jti(decrypt_payload[0]['jti'])
      post = user.posts.new(post_params)
  
      if post.save
        render json: post, status: :created
      else
        render json: post.errors, status: :unprocessable_entity
      end
    end
  
    private
  
      def post_params
        params.require(:post).permit(:title, :description, :post_image)
      end
  
      def decrypt_payload
        jwt = request.headers["Authorization"]
        token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
      end
end
