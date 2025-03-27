class IssueSerializer < ActiveModel::Serializer
  attributes :id, :name, :link, :cover, :cover_url, :created_at, :description, :podcast_id, :url

  def cover
    object.cover.present? ? object.cover : 'fallback_image.jpg'
  end

  def cover_url
    object.cover.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.cover, host: "http://localhost:3000") : nil
  end

  # Метод для получения URL конкретного выпуска
  def url
    Rails.application.routes.url_helpers.api_v1_podcast_issue_url(object.podcast_id, object.id)
  end
end