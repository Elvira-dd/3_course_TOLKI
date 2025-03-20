class MainController < ApplicationController
  def index
    @podcasts = Podcast.all
    @science_podcasts = Podcast.where(id: [2, 6, 4, 7, 13])
    @love_podcasts = Podcast.where(id: [1,5,8,9, 20])
    @authors = Author.all
    @issues = Issue.all
    @profile_top = Author.where(id: [ 1, 2, 3,4])
    @new_podcast = Podcast.find_by(id: 8)
    @latest_issue_for_new_podcast = @new_podcast.issues.order(created_at: :desc).first
    @ama_podcast = Podcast.find_by(id: 2)
    @themes = Theme.where(id: [2, 6, 4, 7,8,9,10])
    @chart_podcasts = Issue.where(id: [15,47,8,32])
  end

end
