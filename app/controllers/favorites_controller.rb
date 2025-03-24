class FavoritesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_favoritable, only: [:toggle]
  
    def index
        @favorite_podcasts = current_user.favorite_podcasts
        @favorite_issues = current_user.favorite_issues
        render 'main/favorite'
      end
  
    def toggle
      return redirect_back fallback_location: root_path, alert: "Некорректный запрос" if @favoritable.nil?
  
      favorite = current_user.favorites.find_by(favoritable: @favoritable)
  
      if favorite
        favorite.destroy
        flash[:notice] = "Удалено из избранного"
      else
        current_user.favorites.create!(favoritable: @favoritable)
        flash[:notice] = "Добавлено в избранное"
      end
  
      redirect_back fallback_location: root_path
    end
  
    private
  
    def find_favoritable
      if params[:type].present? && params[:id].present?
        begin
          @favoritable = params[:type].constantize.find_by(id: params[:id])
        rescue NameError
          @favoritable = nil
        end
      end
    end
  end