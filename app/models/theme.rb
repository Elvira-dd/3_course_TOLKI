class Theme < ApplicationRecord
    has_and_belongs_to_many :podcasts

  # валидация уникальности имени темы
  validates :name, presence: true, uniqueness: true
end
