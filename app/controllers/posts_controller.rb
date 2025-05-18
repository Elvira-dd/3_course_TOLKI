class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_post, only: %i[ show edit update destroy like ]
  

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end
  def like 
      @post = Post.find(params[:id])  
      @commentable = @post 

    likes = @post.likes.where(user_id: current_user.id)
    @post.dislikes.where(user_id: current_user.id).destroy_all 

    if likes.count > 0
      likes.destroy_all
    else
      @post.likes.create(user_id: current_user.id)
    end
    redirect_back fallback_location: @post
  end

  def dislike
    @post = Post.find(params[:id])

    @post.likes.where(user_id: current_user.id).destroy_all 

    dislikes = @post.dislikes.where(user_id: current_user.id)

    if dislikes.exists?
      dislikes.destroy_all
    else
      @post.dislikes.create(user_id: current_user.id)
    end

    redirect_back fallback_location: @post  # Перенаправляем на пост или другой ресурс
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find_by(id: params[:id]) 
    @commentable = @post 
    @user = current_user
  end

  # GET /posts/new
  def new
    @post = Post.new
    @podcasts = Podcast.all
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    render :new
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :hashtag, :author_id)
    end
end
