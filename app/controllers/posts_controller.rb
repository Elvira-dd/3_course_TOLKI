class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_post, only: %i[ show edit update destroy like ]
  

  # GET /posts or /posts.json
  def index
    if current_user
      @posts = current_user.posts
    else
    @posts = Post.where(is_comments_open: false)
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @issue = Issue.find(params[:issue_id]) # Ensure you have access to the issue
    @post = @issue.posts.new(post_params.merge(user_id: current_user.id))
  
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
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
  def like 
    likes = @post.likes.where(user_id: current_user.id)
    if likes.count > 0
      likes.destroy_all
    else
      @post.likes.create(user_id: current_user.id)
    end
    redirect_to @post
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
      params.require(:post).permit(:title, :content, :is_comments_open, :link, :hashtag)
    end
    
end
