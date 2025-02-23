class Issue < ApplicationRecord
    belongs_to :podcast
    has_many :comments, as: :commentable, dependent: :destroy
  end