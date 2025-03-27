class Issue < ApplicationRecord
    belongs_to :podcast
    has_many :comments, as: :commentable, dependent: :destroy

    has_many :likes, as: :likeable
    has_many :dislikes, as: :dislikeable

    has_many :favorites, as: :favoritable, dependent: :destroy


    has_many :playlist_items, dependent: :destroy
  has_many :playlists, through: :playlist_items

  has_one_attached :cover

  def cover_url
    cover.attached? ? Rails.application.routes.url_helpers.rails_blob_url(cover, host: "http://localhost:3000") : nil
  end
  
  end