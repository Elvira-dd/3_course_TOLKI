class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_commentable, only: [:create, :destroy, :like]
  before_action :set_comment, only: %i[edit update destroy like]

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
    @comment.dislikes.where(user_id: current_user.id).destroy_all
    likes = @comment.likes.where(user_id: current_user.id)
  
    if likes.exists?
      likes.destroy_all
    else
      @comment.likes.create(user_id: current_user.id)
    end
  
    redirect_to @comment.commentable  # Перенаправляем на пост или другой ресурс
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

    redirect_to @comment.commentable  # Перенаправляем на пост или другой ресурс
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
    return if %w[like dislike].include?(action_name) # Пропускаем для лайков и дизлайков
  
    if params[:comment].present? && params[:comment][:commentable_type].present? && params[:comment][:commentable_id].present?
      begin
        @commentable = params[:comment][:commentable_type].constantize.find_by(id: params[:comment][:commentable_id])
  
        unless @commentable
          Rails.logger.warn "Commentable not found: #{params[:comment][:commentable_type]} with ID #{params[:comment][:commentable_id]}"
          return head :not_found
        end
      rescue NameError => e
        Rails.logger.error "Invalid commentable_type: #{params[:comment][:commentable_type]}"
        return head :unprocessable_entity
      end
    else
      Rails.logger.warn "Missing commentable_type or commentable_id in params: #{params[:comment].inspect}"
      return head :unprocessable_entity
    end
  end

  # Находим комментарий
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Разрешенные параметры
  def comment_params
    params.require(:comment).permit(:content, :comment_id, :commentable_type, :commentable_id)
  end
end