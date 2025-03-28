class Api::V1::ProfilesController < ApplicationController
    before_action :set_profile, only: [:show]
  
    def index
      @profiles = Profile.includes(:user) # Предотвращаем N+1 запрос
      render json: @profiles, status: :ok
    end
  
    def show
      render json: @profile, status: :ok
    end
  
  
    private
  
    def set_profile
      @profile = Profile.find(params[:id])
    end
  end