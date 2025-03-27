class IssueSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :cover_url, :podcast_id

  def cover_url
    object.cover.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.cover, host: "http://localhost:3000") : nil
  end
end