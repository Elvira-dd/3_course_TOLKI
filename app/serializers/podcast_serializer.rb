class PodcastSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :average_rating, :cover_url, :external_links, :is_audio

  # Ссылка на связанные issues
  def issues_url
    api_v1_podcast_issues_url(object.id)  # Это создаст URL для получения issues подкаста
  end

  def cover_url
    object.cover.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.cover, host: "http://localhost:3000") : nil
  end
end