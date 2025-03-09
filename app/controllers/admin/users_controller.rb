class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end
  def profile
    @user = current_user
    @posts = @user.posts
  
  

  @days_in_app = (Date.today - @user.created_at.to_date).to_i
  end

  def show
    @users = Profile.where.not(user: current_user)
  end
end
