class Admin::PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_post, only: %i[ show edit update destroy ]
  

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/new

  def new
    @post = Post.new
    @podcasts = Podcast.all
    @simplified_podcasts = @podcasts.map do |podcast|
      {
        id: podcast.id,
        name: podcast.name,
        issues: podcast.issues.map { |issue| { id: issue.id, name: issue.name } }
      }
    end
  end

  # GET /posts/1/edit
  def edit
  end
  

  # POST /posts or /posts.json
  
  def create
    @post = current_user.posts.new(post_params)
  
    if @post.save
      redirect_to @post, notice: 'Пост был успешно создан.'
    else
      @podcasts = Podcast.all # Загрузи данные заново, чтобы избежать проблем при повторном рендеринге
      render :new, status: :unprocessable_entity
    end
    
  end
  
  def like 
    likes = @post.likes.where(user_id: current_user.id)
    if likes.count > 0
      likes.destroy_all
    else
      @post.likes.create(user_id: current_user.id)
    end
    redirect_to admin_post_path(@post)
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to admin_post_path(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!
  
    respond_to do |format|
      format.html { redirect_to admin_posts_path, status: :see_other, notice: "Post was successfully destroyed." }
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
      params.require(:post).permit(:title, :content, :hashtag, :issue_id, :user_id)
    end
    
end
