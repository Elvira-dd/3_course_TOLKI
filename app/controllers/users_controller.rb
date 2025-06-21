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
    @reviews = @user.reviews

  @days_in_app = (Date.today - @user.created_at.to_date).to_i
  @playlists = @user.playlists.limit(4)
  @last_comment = @user.comments.order(created_at: :desc).first
  @last_commentable = @last_comment.commentable if @last_comment.present?
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
  end
  def update_favorite_themes
  ids = params[:favorite_themes].to_s.split(",").map(&:to_i)
  theme_names = Theme.where(id: ids).pluck(:name)

  current_user.profile.update(favorite_themes: theme_names.join(", "))
  redirect_to my_profile_path, notice: "Темы успешно сохранены!"
end
end
