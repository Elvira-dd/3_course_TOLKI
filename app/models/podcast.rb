class Podcast < ApplicationRecord
    has_many :tags
    has_many :issues
    has_many :posts
    has_and_belongs_to_many :authors
    has_many :reviews, dependent: :destroy
    has_and_belongs_to_many :themes

    has_one_attached :cover

    has_many :favorites, as: :favoritable, dependent: :destroy
end
