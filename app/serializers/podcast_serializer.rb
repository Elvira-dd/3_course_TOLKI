class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :average_rating, :cover, :cover_url, :external_links, :is_audio

  has_many :issues, serializer: IssueSerializer

  def cover
    object.cover.attached? ? object.cover.filename.to_s : nil
  end

  def cover_url
    object.cover.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.cover, host: "http://localhost:3000") : nil
  end
end