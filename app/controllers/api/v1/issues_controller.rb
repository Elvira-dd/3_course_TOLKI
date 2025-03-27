class Api::V1::IssuesController < ApplicationController
  def index
    @podcast = Podcast.find(params[:podcast_id])
    render json: @podcast.issues
  end
  
  def show
    @issue = Issue.find(params[:id])
    render json: @issue, serializer: IssueSerializer
  end
end