class SearchController < ApplicationController
    def index
      @query = params[:query]
      if @query.present?
        @results = Podcast.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{@query.downcase}%", "%#{@query.downcase}%")
      else
        @results = []
      end
    end
  end