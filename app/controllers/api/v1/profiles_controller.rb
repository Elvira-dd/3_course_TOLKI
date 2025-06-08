class Api::V1::ProfilesController < ApplicationController
    before_action :set_profile, only: [:show]
  
    def index
      @profiles = Profile.includes(:user) # Предотвращаем N+1 запрос
      render json: @profiles, status: :ok
    end
  
    def show
      render json: @profile, status: :ok
    end
  def update
    profile = current_user.profile
    if profile.update(profile_params)
      render json: profile, status: :ok
    else
      render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
    private
  
    def set_profile
      @profile = Profile.find(params[:id])
    end
    def profile_params
    params.require(:profile).permit(:name, :bio, :level, :avatar)
  end
  end