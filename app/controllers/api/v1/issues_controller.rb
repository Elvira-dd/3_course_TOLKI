class Api::V1::IssuesController < ApplicationController
  def index
    # Получаем все issues или фильтруем по подкасту, если передан podcast_id
    if params[:podcast_id]
      @issues = Podcast.find(params[:podcast_id]).issues
    else
      @issues = Issue.all
    end
    render json: @issues, each_serializer: IssueSerializer
  end

  def show
    @issue = Issue.find(params[:id])
    render json: @issue, serializer: IssueSerializer
  end
end