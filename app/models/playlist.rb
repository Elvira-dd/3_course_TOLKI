class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_items, dependent: :destroy
  has_many :issues, through: :playlist_items

  validates :name, presence: true
end