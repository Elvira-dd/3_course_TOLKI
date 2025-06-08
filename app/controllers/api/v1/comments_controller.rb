class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user!

  before_action :set_commentable, only: [:create, :destroy, :like]
  before_action :set_comment, only: %i[edit update destroy like]

  def index
  @comments = Comment.all

  render :index  
end

  # GET /comments/new
  def new
    @comment = Comment.find(params[:id])
    @user = current_user
    @comment = @commentable.comments.new
  end
  def show
    @comment = Comment.find(params[:id])
    @user = current_user
    @commentable = @comment.commentable
  end
  # POST /comments
  def create
    unless current_user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end
  
    @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))
  
    if params[:comment][:parent_id].present?
      @comment.parent_id = params[:comment][:parent_id] # исправлено (было comment_id)
    end
  
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def like
    @comment = Comment.find(params[:id])
    @comment.dislikes.where(user_id: current_user.id).destroy_all
    likes = @comment.likes.where(user_id: current_user.id)
  
    if likes.exists?
      likes.destroy_all
    else
      @comment.likes.create(user_id: current_user.id)
    end
  
    redirect_back(fallback_location: root_path)
  end

  def dislike
    @comment = Comment.find(params[:id])
    @comment.likes.where(user_id: current_user.id).destroy_all 
    dislikes = @comment.dislikes.where(user_id: current_user.id)

    if dislikes.exists?
      dislikes.destroy_all
    else
      @comment.dislikes.create(user_id: current_user.id)
    end

    redirect_back(fallback_location: root_path)  # Перенаправляем на пост или другой ресурс
  end

  # GET /comments/1/edit
  def edit; end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: "Комментарий успешно обновлен."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to @comment.commentable, notice: "Комментарий успешно удален.", status: :see_other
  end

  private

  # Определяем, к какому объекту (Post или Issue) относится комментарий
  def set_commentable
  type = params[:comment][:commentable_type]
  id = params[:issue_id] || params[:comment][:commentable_id]

  @commentable = type.constantize.find_by(id: id)

  head :not_found unless @commentable
end

  # Находим комментарий
  def set_comment
    @comment = Comment.find_by(id: params[:id])
  
    unless @comment
      render json: { error: "Comment not found" }, status: :not_found
    end
  end

  # Разрешенные параметры
  def comment_params
    params.require(:comment).permit(:content, :comment_id, :commentable_type, :commentable_id)
  end
end