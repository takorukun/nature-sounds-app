class Video < ApplicationRecord
  before_validation :assign_youtube_video_id
  belongs_to :user
  acts_as_taggable

  validates_presence_of :youtube_video_id
  validates :title, presence: true
  validate :allowed_tags
  validates :description, length: { maximum: 500 }, allow_blank: true

  private

  def self.ransackable_attributes(auth_object = nil)
    [
      "channel_id", "created_at", "description", "duration", "id", "thumbnail_url", "title", "updated_at", "user_id",
      "youtube_video_id",
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["base_tags", "tag_taggings", "taggings", "tags", "user"]
  end

  def assign_youtube_video_id
    if youtube_video_id.present? && youtube_video_id.include?("youtube.com")
      self.youtube_video_id = YoutubeService.extract_youtube_video_id(youtube_video_id)
    end
  end

  def allowed_tags
    allowed = ["焚き火", "森林", "洞窟", "川", "雨", "海", "夜", "海中"]
    tag_list.each do |tag|
      errors.add(:tag_list, "に不正なタグが含まれています") unless allowed.include?(tag)
    end
  end
end
