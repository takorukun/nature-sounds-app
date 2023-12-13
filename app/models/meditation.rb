class Meditation < ApplicationRecord
  validates_presence_of :duration
  validates_presence_of :date
  validates :notes, length: { maximum: 500 }, allow_blank: true

  def self.sessions_for_user(user, start_date, end_date)
    where(user_id: user, date: start_date..end_date)
  end

  belongs_to :user
  belongs_to :video
end
