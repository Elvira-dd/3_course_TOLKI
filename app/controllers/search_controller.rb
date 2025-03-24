class SearchController < ApplicationController
  def index
    @query = params[:query].downcase
    @type = params[:type]

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