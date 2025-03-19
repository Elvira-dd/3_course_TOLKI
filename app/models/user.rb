class User < ApplicationRecord

  include Devise::JWT::RevocationStrategies::JTIMatcher
         

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :likes
  has_many :dislikes
  
  has_many :comments
  has_one :profile, dependent: :destroy
  has_one :author

  after_create :create_profile_and_author

  private

  def create_profile_and_author
    create_profile
    create_author if is_author?
  end

  def create_profile
    Profile.create!(
      user: self,
      name: "Default User #{id}",
      bio: "This is the default bio for user #{email}.",
      avatar: "default_avatar.png",
      level: random_rating
    )
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