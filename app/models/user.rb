class User < ApplicationRecord
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def guest?
    email == 'guest@example.com'
  end

  has_one_attached :avatar
  has_many :meditations
  has_many :owned_videos, class_name: "Video"
  has_many :favorites
  has_many :favorited_videos, through: :favorites, source: :video
  belongs_to :purpose_of_meditation, optional: true
end
