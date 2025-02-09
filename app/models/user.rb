class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :likes
  has_many :posts
  has_many :comments
  has_one :profile, dependent: :destroy

  after_create :create_profile

  private

  def create_profile
    Profile.create!(
      user: self,
      name: "Default User #{id}", 
      bio: "This is the default bio for user #{email}.",
      avatar: "default_avatar.png",
      level: random_rating
    )
  end

  def random_rating
    rand(1..100) 
  end
end