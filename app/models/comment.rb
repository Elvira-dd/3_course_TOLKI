class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :parent_comment, class_name: "Comment", foreign_key: "comment_id", optional: true

  has_many :replies, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :dislikes, as: :dislikeable, dependent: :destroy

  validates :content, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :not_replies, -> { where(comment_id: nil) }
end