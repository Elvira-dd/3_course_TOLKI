class SearchController < ApplicationController
  def index
    @query = params[:query].downcase
    @type = params[:type]

    @rec_posts = Post.where(id: [2, 6, 4, 7, 13])
    @rec_podcasts = Podcast.where(id: [2, 6, 4, 7, 13])
    @rec_authors = Author.where(id: [4, 1, 2])
    @rec_issues = Issue.where(id: [2, 6, 4, 7, 13])

    case @type
    when "posts"
      @results = Post.where("LOWER(title) LIKE ?", "%#{@query}%")
    when "podcasts"
      @results = Podcast.where("LOWER(name) LIKE ?", "%#{@query}%")
    when "issues"
      @results = Issue.where("LOWER(name) LIKE ?", "%#{@query}%")
    when "authors"
      @results = Author.joins(user: :profile).where("LOWER(profiles.name) LIKE ?", "%#{@query}%")
    else
      @results = (Post.where("LOWER(title) LIKE ?", "%#{@query}%") +
                  Podcast.where("LOWER(name) LIKE ?", "%#{@query}%") +
                  Issue.where("LOWER(name) LIKE ?", "%#{@query}%") +
                  Author.joins(user: :profile).where("LOWER(profiles.name) LIKE ?", "%#{@query}%")).uniq
    end
  end
end