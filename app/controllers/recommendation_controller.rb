class RecommendationController < ApplicationController
  def index
    @themes = Theme.all
    @podcasts_top = Podcast.where(id: [2, 6, 4, 7, 1, 8, 10, 3])
    @popular_authors = Author.where(id: [1, 3, 4])
    @popular_podcast = Podcast.find(17)
    @feed = (Issue.where(id: [3, 4, 5, 6, 11, 8, 9]).to_a + Post.where(id: [2, 3, 4, 5]).to_a).shuffle

    if user_signed_in?
      @subs_podcast = current_user.favorite_podcasts
      @subs_feed = Post.where(podcast_id: @subs_podcast.pluck(:id)) + Issue.where(podcast_id: @subs_podcast.pluck(:id))
      @subs_authors = @subs_podcast.map(&:authors).flatten.uniq
    else
      @subs_podcast = []
      @subs_feed = []
      @subs_authors = []
    end
  end
end