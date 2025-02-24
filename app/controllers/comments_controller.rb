class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_commentable, only: [:create, :destroy, :like]
  before_action :set_comment, only: %i[edit update destroy like]

  # GET /comments/new
  def new
    @comment = @commentable.comments.new
  end

  # POST /comments
  def create
    @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))

    # Проверяем, является ли это ответом на комментарий
    if params[:comment][:comment_id].present?
      @comment.comment_id = params[:comment][:comment_id]
    end

    if @comment.save
      redirect_to @commentable, notice: "Комментарий успешно добавлен."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def like
    @comment = Comment.find(params[:id])
    likes = @comment.likes.where(user_id: current_user.id)

    if likes.exists?
      likes.destroy_all
    else
      @comment.likes.create(user_id: current_user.id)
    end
    redirect_to @comment.commentable
  end

  def dislike
    @comment = Comment.find(params[:id])
    dislikes = @comment.dislikes.where(user_id: current_user.id)

    if dislikes.exists?
      dislikes.destroy_all
    else
      @comment.dislikes.create(user_id: current_user.id)
    end
    redirect_to @comment.commentable
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
    if params[:commentable_type] && params[:commentable_id]
      @commentable = params[:commentable_type].constantize.find(params[:commentable_id])
    else
      head :unprocessable_entity
    end
  end

  # Находим комментарий
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Разрешенные параметры
  def comment_params
    params.require(:comment).permit(:content, :comment_id)
  end
end