class Podcast < ApplicationRecord
    has_many :tags
    has_many :issues
    has_many :posts, through: :issues
    has_and_belongs_to_many :authors
    has_and_belongs_to_many :themes
end
