class User < ApplicationRecord
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def self.users_meeting_purpose_requirements(purpose_id, frequency, duration, total_weeks)
    User.joins(:meditations).
      where(purpose_of_meditation_id: purpose_id).
      group("users.id").
      having("COUNT(meditations.id) >= ? AND SUM(meditations.duration) >= ?",
              frequency * total_weeks, duration * frequency * total_weeks).
      select("users.*")
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
