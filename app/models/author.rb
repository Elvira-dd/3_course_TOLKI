class Author < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :podcasts
    has_many :posts
    validates :user_id, uniqueness: true

    has_many :author_subscriptions
has_many :subscribers, through: :author_subscriptions, source: :user
end
