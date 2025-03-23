class Review < ApplicationRecord
  belongs_to :user
  belongs_to :podcast

  TAG_OPTIONS = ["Интересная тема обсуждений", "Хорошая динамика беседы", "Глубокий анализ материала", "Структура повествования", "Оригинальность, инсайды", "Доступность, понятность"]

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :tags, inclusion: { in: TAG_OPTIONS }, allow_blank: true
end