class UsersController < ApplicationController
  def index
    @users = User.all
  end
 def profile
  @user = current_user

  if @user.is_author
    @author = Author.find_by(user_id: @user.id)
    @podcasts = @author.podcasts.limit(5)
  end

  @comments = @user.comments.where(comment_id: nil)
  @reviews_all = @user.reviews
  @reviews = @user.reviews.limit(3)

  @days_in_app = (Date.today - @user.created_at.to_date).to_i
  @playlists = @user.playlists.limit(4)

  @last_comment = @user.comments.order(created_at: :desc).first
  @last_commentable = @last_comment.commentable if @last_comment.present?

  likes = @user.likes.includes(:likeable)
  @liked_posts = likes.select { |like| like.likeable_type == "Post" }.map(&:likeable)
  @liked_issues = likes.select { |like| like.likeable_type == "Issue" }.map(&:likeable)
  @liked_posts1 = likes.select { |like| like.likeable_type == "Post" }.map(&:likeable).last(1)
  @liked_issues1 = likes.select { |like| like.likeable_type == "Issue" }.map(&:likeable).last(1)

  # Выборка комментированных постов и выпусков
  commented_ids = @user.comments.select(:commentable_id, :commentable_type).distinct
  post_ids = commented_ids.where(commentable_type: "Post").pluck(:commentable_id)
  issue_ids = commented_ids.where(commentable_type: "Issue").pluck(:commentable_id)

  @commented_posts = Post.where(id: post_ids)
  @commented_issues = Issue.where(id: issue_ids)
end
def setting
  @user = current_user
  @themes = Theme.all.limit(17)
end
def show
  @users = Profile.where.not(user: current_user)
  @user = User.find(params[:id])

  @comments = @user.comments.where(comment_id: nil)
  @reviews = @user.reviews
  @playlists = @user.playlists.limit(4)
  @days_in_app = (Date.today - @user.created_at.to_date).to_i

  @last_comment = @user.comments.order(created_at: :desc).first
  @last_commentable = @last_comment.commentable if @last_comment.present?

  likes = @user.likes.includes(:likeable)
  @liked_posts = likes.select { |like| like.likeable_type == "Post" }.map(&:likeable)
  @liked_issues = likes.select { |like| like.likeable_type == "Issue" }.map(&:likeable)
  @liked_posts1 = likes.select { |like| like.likeable_type == "Post" }.map(&:likeable).last(1)
  @liked_issues1 = likes.select { |like| like.likeable_type == "Issue" }.map(&:likeable).last(1)
  @reviews_all = @user.reviews

  # Все посты и выпуски, где есть его комментарии
  commented_ids = @user.comments.select(:commentable_id, :commentable_type).distinct

  post_ids = commented_ids.where(commentable_type: "Post").pluck(:commentable_id)
  issue_ids = commented_ids.where(commentable_type: "Issue").pluck(:commentable_id)

  @commented_posts = Post.where(id: post_ids)
  @commented_issues = Issue.where(id: issue_ids)
end

  def update_favorite_themes
  ids = params[:favorite_themes].to_s.split(",").map(&:to_i)
  theme_names = Theme.where(id: ids).pluck(:name)

  current_user.profile.update(favorite_themes: theme_names.join(", "))
  redirect_to my_profile_path
  
end
end
