class Admin::PodcastsController < ApplicationController
  load_and_authorize_resource
  before_action :set_podcast, only: %i[show edit update destroy]
  def issues
    podcast = Podcast.find(params[:id])
    render json: podcast.issues.select(:id, :name)
  end

  # GET /admin/podcasts
  def index
    @podcasts = Podcast.all
  end

  # GET /admin/podcasts/1
  def show
    @issues = Issue.where(link: @podcast.name)
    @authors = @podcast.authors

    @podcast = Podcast.find(params[:id])
    @posts = @podcast.posts.includes(:issue)
  end

  # GET /admin/podcasts/new
  def new
    @podcast = Podcast.new
  end

  # GET /admin/podcasts/1/edit
  def edit
  end

  # POST /admin/podcasts
  def create
    respond_to do |format|
      if @podcast.save
        format.html { redirect_to admin_podcast_path(@podcast), notice: "Podcast was successfully created." }
        format.json { render :show, status: :created, location: @podcast }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @podcast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/podcasts/1
  def update
    respond_to do |format|
      if @podcast.update(podcast_params)
        format.html { redirect_to admin_podcast_path(@podcast), notice: "Podcast was successfully updated." }
        format.json { render :show, status: :ok, location: @podcast }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @podcast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/podcasts/1
  def destroy
    @podcast.issues.destroy_all
    @podcast.destroy!
  
    respond_to do |format|
      format.html { redirect_to admin_podcasts_path, status: :see_other, notice: "Podcast was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_podcast
    @podcast = Podcast.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def podcast_params
    params.require(:podcast).permit(:name, :description, author_ids: [])
  end
end
