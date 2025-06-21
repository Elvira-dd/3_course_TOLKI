class RecommendationController < ApplicationController
  def index
    @themes = Theme.all
    @podcasts_top = Podcast.where(id: [2, 6, 4, 7, 1, 8, 10, 3])
    @popular_authors = Author.where(id: [1, 3, 4])
    @popular_podcast = Podcast.find(17)
    @feed = (Issue.where(id: [3, 4, 5, 6, 11, 8, 9]).to_a + Post.where(id: [2, 3, 4, 5]).to_a)

    if user_signed_in?
      @subs_podcast = current_user.favorite_podcasts
      subs_theme_names = current_user.profile.favorite_themes.to_s.split(",").map(&:strip)
      themes = Theme.where(name: subs_theme_names)
      
      @popular_podcasts = Podcast.joins(:themes).where(themes: { id: themes.pluck(:id) }).distinct
      @subs_feed = Post.where(podcast_id: @subs_podcast.pluck(:id)) + Issue.where(podcast_id: @subs_podcast.pluck(:id))
      @subs_authors = @subs_podcast.map(&:authors).flatten.uniq
      theme_podcasts = Podcast.joins(:themes).where(themes: { id: themes.ids }).distinct
theme_issues = Issue.where(podcast_id: theme_podcasts.ids).last(2).to_a
theme_posts = Post.where(podcast_id: theme_podcasts.ids).last(2).to_a
theme_issues2 = Issue.where(podcast_id: theme_podcasts.ids).limit(8).to_a
theme_posts2 = Post.where(podcast_id: theme_podcasts.ids).limit(8).to_a
@feed = (theme_issues + theme_posts + theme_issues2 + theme_posts2)
      
      
    else
      @popular_podcasts = Podcast.none
      @subs_podcast = []
      @subs_feed = []
      @subs_authors = []
    end
  end
end