class Theme < ApplicationRecord
    has_and_belongs_to_many :podcasts
has_one_attached :cover
  # валидация уникальности имени темы
  validates :name, presence: true, uniqueness: true
end
