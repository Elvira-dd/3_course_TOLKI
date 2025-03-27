class Api::V1::PodcastsController < ApplicationController
  include Rails.application.routes.url_helpers  # Подключаем helpers для использования url_for
  
  def index
    @podcasts = Podcast.all
    render 'api/v1/podcasts/index', locals: { podcasts: @podcasts, url_for: method(:url_for) }
  end

  def show
    @podcast = Podcast.find(params[:id])  # Загружаем один подкаст
    render 'api/v1/podcasts/show', locals: { podcast: @podcast, url_for: method(:url_for) }
  end
end