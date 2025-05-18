class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def profile
    @user = current_user
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
