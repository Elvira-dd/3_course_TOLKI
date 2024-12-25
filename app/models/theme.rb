class Theme < ApplicationRecord
    has_and_belongs_to_many :podcasts

  # валидация уникальности имени темы
  validates :name, presence: true, uniqueness: true
  has_one_attached :cover
end
