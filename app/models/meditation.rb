class Meditation < ApplicationRecord
  validates_presence_of :duration
  validates_presence_of :date
  validates :notes, length: { maximum: 500 }, allow_blank: true

  belongs_to :user
  belongs_to :video
end
