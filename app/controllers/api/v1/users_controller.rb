class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user!, only: [:me] # Требует аутентификации только для me
    before_action :set_user, only: [:show]
  
    def index
      @users = User.all
      render json: @users.as_json(except: [:created_at, :updated_at])
    end
  
    def show
      render json: @user.as_json(
        except: [:created_at, :updated_at],
        include: { 
          profile: { 
            only: [:name, :bio, :level] 
          }
        }
      )
    end
  
    def me
      render json: {
        id: current_user.id,
        email: current_user.email,
        admin: current_user.admin,
        profile: {
          name: current_user.profile.name,
          bio: current_user.profile.bio,
          level: current_user.profile.level
        }
      }
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  end