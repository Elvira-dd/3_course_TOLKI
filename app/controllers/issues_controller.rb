class IssuesController < ApplicationController
  load_and_authorize_resource
  before_action :set_issue, only: %i[ show edit update destroy ]

  # GET /issues or /issues.json
  def index
    @issues = Issue.all
  end
  
  def issues_for_podcast
    @issues = Issue.where(podcast_id: params[:podcast_id]) # Замените на правильную ассоциацию, если нужно
    respond_to do |format|
      format.json { render json: @issues }
    end
  end
  # GET /issues/1 or /issues/1.json
  def show
    @issue = Issue.includes(posts: { user: :profile }).find(params[:id])
    @posts = if user_signed_in?
      @issue.posts.where.not(id: nil)
    else
      @issue.posts.where(is_comments_open: false).where.not(id: nil)
    end
    @post = Post.new(issue: @issue)
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues or /issues.json
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
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:name, :link, :podcastt, :references)
    end
end

class IssuesController < ApplicationController
  def create
    @podcast = Podcast.find(params[:podcast_id])
    #@comment = @podcast.comments.create(params[:comment])
    @issue = @podcast.issues.create(params[:issue].permit(:name, :link))
    redirect_to podcast_path(@podcast)
  end

  def destroy
    @podcast = Podcast.find(params[:podcast_id])
    @issue = @podcast.issues.find(params[:id])
    @issue.destroy
    redirect_to podcast_path(@podcast)
  end
end