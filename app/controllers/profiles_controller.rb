class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    @profile = Profile.find(params[:id])
    @user = @profile.user
    @comments = @user.comments
    if @profile.user == current_user
      redirect_to my_profile_path  # Редирект на личный профиль
    end
  
  @reviewed_podcasts_count = 2
  @days_in_app = (Date.today - @user.created_at.to_date).to_i
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles or /profiles.json
  def update
  respond_to do |format|
    if @profile.update(profile_params)
      format.html { redirect_to @profile, notice: "Профиль успешно обновлён." }
      format.json { render :show, status: :ok, location: @profile }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @profile.errors, status: :unprocessable_entity }
    end
  end
end
def edit_full
  @profile = Profile.find(params[:id])
  @themes = Theme.all
end
def update_full
  @profile = Profile.find(params[:id])

  if @profile.update(profile_params)
    favorite_theme_ids = params[:favorite_themes].to_s.split(",").map(&:to_i)
    theme_names = Theme.where(id: favorite_theme_ids).pluck(:name)
    @profile.update(favorite_themes: theme_names.join(", "))

    redirect_to my_profile_path, notice: "Профиль успешно обновлён"
  else
    @themes = Theme.all
    render :edit_full, status: :unprocessable_entity
  end
end
def create
  @profile = current_user.build_profile(profile_params)
  @profile.level ||= 1

  respond_to do |format|
    if @profile.save
      format.html { redirect_to setting_reg_path, notice: "Профиль успешно создан." }
      format.json { render :show, status: :created, location: @profile }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @profile.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy!

    respond_to do |format|
      format.html { redirect_to profiles_path, status: :see_other, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:name, :bio, :avatar)
    end
end
