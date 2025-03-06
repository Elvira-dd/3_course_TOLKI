class Author < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :podcasts
    validates :user_id, uniqueness: true
end
