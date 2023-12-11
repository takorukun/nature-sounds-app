class PurposeOfMeditation < ApplicationRecord
  validate :title
  validate :description
  validates :frequency_per_week, numericality: { only_integer: true, greater_than: 0 }
  validates :minutes_per_session, numericality: { only_integer: true, greater_than: 0 }
  validates :total_duration_weeks, numericality: { only_integer: true, greater_than: 0 }

  has_many :users
end
