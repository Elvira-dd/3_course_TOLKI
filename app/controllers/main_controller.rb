class MainController < ApplicationController
  def index
    @podcasts = Podcast.all
    # @podcasts_cards = Podcast.joins(:themes).where(themes: { id: 8 }).distinct
    @podcasts_cards = Podcast.where(id: [2, 6, 4, 7,8,9])
    @authors = Author.all
    @issues = Issue.all
    @profile_top = Author.where(id: [ 1, 2, 3,4])
    @new_podcast = Podcast.find_by(id: 8)
    @latest_issue_for_new_podcast = @new_podcast.issues.order(created_at: :desc).first
    @ama_podcast = Podcast.find_by(id: 2)
    @themes = Theme.where(id: [2, 6, 4, 7,8,9,10])
  end
  def test
    @podcasts = Podcast.all
    # @podcasts_cards = Podcast.joins(:themes).where(themes: { id: 8 }).distinct
    @podcasts_cards = Podcast.where(id: [2, 6, 4, 7,8,9])
    @authors = Author.all
    @issues = Issue.all
    @profile_top = Profile.where(id: [2, 6, 4, 7])
    @new_podcast = Podcast.find_by(id: 8)
    @latest_issue_for_new_podcast = @new_podcast.issues.order(created_at: :desc).first
    @ama_podcast = Podcast.find_by(id: 2)
    @themes = Theme.where(id: [2, 6, 4, 7,8,9,10])
  end
end
