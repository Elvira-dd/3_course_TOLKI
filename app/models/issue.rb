class Issue < ApplicationRecord
    has_many :posts
    belongs_to :podcast
    has_one_attached :cover
end
