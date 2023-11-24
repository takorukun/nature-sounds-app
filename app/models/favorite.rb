class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validate :unique_favorite_per_video

  private

  def unique_favorite_per_video
    if user.favorites.where(video_id: video_id).exists?
      errors.add(:base, "#{video.title}は既にお気に入りに追加されています")
    end
  end
end
