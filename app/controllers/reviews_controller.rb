class ReviewsController < ApplicationController
    before_action :authenticate_user! # Убедимся, что пользователь авторизован
    before_action :set_podcast, only: %i[new create]
    before_action :set_review, only: %i[edit update destroy]
  
    def new
      @review = @podcast.reviews.new
    end
    def show 
      @review = Review.find(params[:id])
    end
  
    def create
      @review = @podcast.reviews.new(review_params)
      @review.user = current_user
  
      if @review.save
        redirect_to @podcast, notice: "Отзыв успешно добавлен."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @review.update(review_params)
        redirect_to @review.podcast, notice: "Отзыв успешно обновлен."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @review.destroy
      redirect_to @review.podcast, notice: "Отзыв удален.", status: :see_other
    end
  
    private
  
    def set_podcast
      @podcast = Podcast.find(params[:podcast_id])
    end
  
    def set_review
      @review = Review.find(params[:id])
    end
  
    def review_params
        params.require(:review).permit(:rating, :content, tags: []).tap do |whitelisted|
          whitelisted[:tags] = params[:review][:tags] & Review::TAG_OPTIONS if params[:review][:tags].present?
        end
      end
  end