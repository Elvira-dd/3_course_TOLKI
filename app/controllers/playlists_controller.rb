class PlaylistsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_playlist, only: [:show, :edit, :update, :destroy, :add_issue, :remove_issue]
  
    def index
      @playlists = current_user.playlists
    end
  
    def show
       @playlist = Playlist.find_by(id: params[:id])  
       
    end
  
    def new
       @playlist = current_user.playlists.new(cover: "theme_cover_1")
    end
  
    def create
  @playlist = current_user.playlists.new(playlist_params)
  @playlist.cover = "theme_cover_1" if @playlist.cover.blank? # дефолтная обложка

  if @playlist.save
    redirect_to @playlist, notice: "Плейлист успешно создан!"
  else
    render :new
  end
end
  
    def edit
    end
  
    def update
      if @playlist.update(playlist_params)
        redirect_to @playlist, notice: "Плейлист обновлен!"
      else
        render :edit
      end
    end
  
    def destroy
      @playlist.destroy
      redirect_to playlists_path, notice: "Плейлист удален."
    end
  
    # Добавить выпуск в плейлист
    def add_issue
      issue = Issue.find(params[:issue_id])
      if @playlist.issues.include?(issue)
        flash[:alert] = "Этот выпуск уже есть в плейлисте!"
      else
        @playlist.issues << issue
        flash[:notice] = "Выпуск добавлен в плейлист!"
      end
      redirect_to @playlist
    end
  
    # Удалить выпуск из плейлиста
    def remove_issue
      issue = Issue.find(params[:issue_id])
      @playlist.issues.delete(issue)
      flash[:notice] = "Выпуск удален из плейлиста!"
      redirect_to @playlist
    end
  
    private
  
    def set_playlist
  @playlist = Playlist.find(params[:id])
    end
  
    def playlist_params
  params.require(:playlist).permit(:name, :cover)
end
  end