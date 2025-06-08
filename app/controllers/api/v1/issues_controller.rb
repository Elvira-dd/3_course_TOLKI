class Api::V1::IssuesController < ApplicationController
  def index
  if params[:podcast_id]
    @issues = Podcast.find(params[:podcast_id]).issues.includes(:comments)
  else
    @issues = Issue.includes(:comments)
  end

  render :index  
end

  def show
    @issue = Issue.find(params[:id])
    render json: @issue, serializer: IssueSerializer
  end
end