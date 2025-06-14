class PodcastsController < ApplicationController
  load_and_authorize_resource
  before_action :set_podcast, only: %i[show edit update destroy]

  def index
    @podcasts = Podcast.all
    @issues = Issue.all
  end

  def show
    @podcast = Podcast.find(params[:id])  
    @issues = @podcast.issues
    @user = current_user if user_signed_in?
    @author = Author.find_by(user_id: @user.id) if user_signed_in?    
    @content_items = (@podcast.issues + @podcast.posts).sort_by(&:created_at)
    @same_podcasts = Podcast.where(id:[5,7,9,20])
    @reviews = @podcast.reviews.limit(3)
    @review = user_signed_in? ? @podcast.reviews.new(user: current_user) : nil

    # Загружаем избранные подкасты только для авторизованных пользователей
    @favorited_podcasts = current_user.favorite_podcasts.pluck(:id) if user_signed_in?
  end

  # GET /podcasts/new
  def new
    @podcast = Podcast.new
  end

  # GET /podcasts/1/edit
  def edit
  end

  # POST /podcasts or /podcasts.json
  def create
  @podcast = Podcast.new(podcast_params)
  @podcast.authors << current_user.author  # <-- назначаем текущего автора

  # Если у тебя есть вложенные ссылки – обработай их отдельно
  if podcast_params[:external_links]
  @podcast.external_links = podcast_params[:external_links]
    .to_h
    .reject { |_k, v| v.blank? }
    .map { |service, url| { service: service, url: url } }
end
@podcast.cover ||= "cover_test.png"
  if @podcast.save
    redirect_to @podcast, notice: "Подкаст успешно создан"
  else
    render :new, status: :unprocessable_entity
  end
end

  # PATCH/PUT /podcasts/1 or /podcasts/1.json
  def update
  raw_links = podcast_params[:external_links] || {}
  external_links = raw_links.to_h.map do |service, url|
    next if url.blank?
    { service: service, url: url }
  end.compact

  podcast_attributes = podcast_params.except(:external_links).merge(external_links: external_links)

  respond_to do |format|
    if @podcast.update(podcast_attributes)
      format.html { redirect_to @podcast, notice: "Podcast was successfully updated." }
      format.json { render :show, status: :ok, location: @podcast }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @podcast.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /podcasts/1 or /podcasts/1.json
  def destroy
    @podcast.destroy!

    respond_to do |format|
      format.html { redirect_to podcasts_path, status: :see_other, notice: "Podcast was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])  # Этот метод уже устанавливает @podcast
    end

    # Only allow a list of trusted parameters through.
    def podcast_params
  params.require(:podcast).permit(:name, :description, :cover, :average_rating, theme_ids: [], external_links: {})
end
end