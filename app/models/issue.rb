class Issue < ApplicationRecord
    has_many :posts
    belongs_to :podcast
end
