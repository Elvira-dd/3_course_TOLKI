class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :issue

  validates :issue_id, uniqueness: { scope: :playlist_id, message: "Этот выпуск уже есть в плейлисте" }
end