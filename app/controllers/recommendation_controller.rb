class RecommendationController < ApplicationController
  def index
    @themes = Theme.all
    @podcasts_top = Podcast.where(id: [2, 6, 4, 7, 1, 8])
  end
end
