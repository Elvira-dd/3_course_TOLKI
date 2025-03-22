class RecommendationController < ApplicationController
  def index
    @themes = Theme.all
    @podcasts_top = Podcast.where(id: [2, 6, 4, 7, 1, 8,10,3])
    @popular_authors = Author.where(id: [1,3,4])
    @popular_podcast = Podcast.find(17)
    @feed = (Issue.where(id: [3, 4, 5, 6, 11, 8, 9]).to_a + Post.where(id: [2, 3, 4, 5]).to_a).shuffle
  end
end
