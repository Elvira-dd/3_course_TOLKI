class Post < ApplicationRecord
    belongs_to :podcast
    belongs_to :user 
    has_many :comments, as: :commentable, dependent: :destroy

    validates :title, presence: true
    validates :content, presence: true
    validates :link, presence: true

    def as_json 
        {
            title: title
        }
    end
    has_many :likes, as: :likeable
end
