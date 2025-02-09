class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def profile
    @user = current_user
    @posts = @user.posts
  
  @reviewed_podcasts_count = @user.posts.joins(:issue).select("distinct issues.podcast_id").count
  @posts_count = @user.posts.count
  @days_in_app = (Date.today - @user.created_at.to_date).to_i
  end

  def show
    @users = Profile.where.not(user: current_user)
  end
end
