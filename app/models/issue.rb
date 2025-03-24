class Issue < ApplicationRecord
    belongs_to :podcast
    has_many :comments, as: :commentable, dependent: :destroy

    has_many :likes, as: :likeable
    has_many :dislikes, as: :dislikeable

    has_many :favorites, as: :favoritable, dependent: :destroy
  end