class Dislike < ApplicationRecord
  belongs_to :user
  belongs_to :dislikeable, polymorphic: true
end
