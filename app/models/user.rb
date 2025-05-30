class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
         
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :likes
  has_many :dislikes
  has_many :reviews, dependent: :destroy
  has_many :comments
  has_one :profile, dependent: :destroy
  has_one :author
  has_many :playlists, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_podcasts, through: :favorites, source: :favoritable, source_type: 'Podcast'
  has_many :favorite_issues, through: :favorites, source: :favoritable, source_type: 'Issue'

  after_create :create_profile_and_author
  
  def jwt_payload
  super.merge({ sub: id, scope: 'user' })  # ← добавляем sub
end
  private

  def create_profile_and_author
    create_profile
    create_author if is_author?
  end

  def create_profile
    # Получаем все файлы с аватарами из папки
    avatar_files = Dir.entries(Rails.root.join('app', 'assets', 'images', 'profile_avatars')).select { |file| file.match?(/\.png$/) }

    # Если в папке есть аватары, выбираем случайный
    if avatar_files.any?
      random_avatar = avatar_files.sample
      avatar_path = Rails.root.join('app', 'assets', 'images', 'profile_avatars', random_avatar)
    else
      avatar_path = Rails.root.join('app', 'assets', 'images', 'profile_avatars', 'default_avatar.png')
    end

    # Создаем профиль пользователя с выбранным аватаром через ActiveStorage
    profile = Profile.create!(
      user: self,
      name: "Default User #{id}",
      bio: "This is the default bio for user #{email}.",
      level: random_rating
    )

    # Привязываем аватар к профилю с помощью ActiveStorage
    profile.avatar.attach(io: File.open(avatar_path), filename: File.basename(avatar_path))

    profile
  end

  def create_author
    author = Author.create!(
      user: self,
      exten_bio: "BIO FOR AUTHOR #{self.id}" 
    )
    author.update(exten_bio: "BIO FOR AUTHOR #{author.id}") 
  end

  def random_rating
    rand(1..100)
  end
end