class IssuesController < ApplicationController
  load_and_authorize_resource
  before_action :set_issue, only: %i[ show edit update destroy ]

  # GET /issues or /issues.json
  def index
    @podcast = Podcast.find(params[:podcast_id])
    @issues = @podcast.issues
  end
  
  def issues_for_podcast
    @issues = Issue.where(podcast_id: params[:podcast_id]) # Замените на правильную ассоциацию, если нужно
    respond_to do |format|
      format.json { render json: @issues }
    end
  end

  def like 
  @issue = Issue.find(params[:id])  
    @commentable = @issue 

  likes = @issue.likes.where(user_id: current_user.id)
  @issue.dislikes.where(user_id: current_user.id).destroy_all 

  if likes.count > 0
    likes.destroy_all
  else
    @issue.likes.create(user_id: current_user.id)
  end
  redirect_back fallback_location: @issue
end

def dislike
  @issue = Issue.find(params[:id])

  @issue.likes.where(user_id: current_user.id).destroy_all 

  dislikes = @issue.dislikes.where(user_id: current_user.id)

  if dislikes.exists?
    dislikes.destroy_all
  else
    @issue.dislikes.create(user_id: current_user.id)
  end

  redirect_back fallback_location: @issue  # Перенаправляем на пост или другой ресурс
end


  # GET /issues/1 or /issues/1.json
  def show
    @issue = Issue.find_by(id: params[:id])  
    @favorited_issues = current_user.favorite_podcasts.pluck(:id)
  if @issue.nil?
    Rails.logger.error "Issue with ID #{params[:id]} not found"
    return head :not_found
  end
  @commentable = @issue
  @reviews = @issue.podcast.reviews.limit(3)
  @user = current_user
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # issue /issues or /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1 or /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: "Issue was successfully updated." }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    @issue.destroy!

    respond_to do |format|
      format.html { redirect_to issues_path, status: :see_other, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      Rails.logger.info "Trying to find Issue with ID #{params[:id]}"
  @issue = Issue.find_by(id: params[:id])

  unless @issue
    Rails.logger.error "Issue not found!"
    return head :not_found
  end
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:name, :link, :podcastt, :references)
    end
end

