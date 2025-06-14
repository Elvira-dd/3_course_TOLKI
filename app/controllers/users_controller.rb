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
  end

  def show
    @users = Profile.where.not(user: current_user)
    @user = User.find(params[:id])
 @comments = @user.comments.where(comment_id: nil)
    @reviews = @user.reviews
@playlists = @user.playlists.limit(4)
  @days_in_app = (Date.today - @user.created_at.to_date).to_i
  end
end
