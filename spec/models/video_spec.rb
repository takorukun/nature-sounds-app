require 'rails_helper'

RSpec.describe Video, type: :model do
  let(:valid_youtube_link) { 'https://www.youtube.com/watch?v=sampleID91011' }
  let(:invalid_link) { 'https://www.someotherwebsite.com/watch?v=sampleID91011' }
  let(:user) { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      video = build(:video, youtube_video_id: valid_youtube_link, title: 'Sample Title', user: user)
      expect(video).to be_valid
    end

    it 'is invalid without a youtube_video_id' do
      video = build(:video, youtube_video_id: nil)
      expect(video).not_to be_valid
    end

    it 'is invalid without a title' do
      video = build(:video, title: nil)
      expect(video).not_to be_valid
    end

    it 'is invalid with a description longer than 500 characters' do
      long_description = 'a' * 501
      video = build(:video, description: long_description, user: user)
      expect(video).not_to be_valid
    end

    it 'is valid with a description of 500 characters or less' do
      description = 'a' * 500
      video = build(:video, description: description, user: user)
      expect(video).to be_valid
    end

    it 'assigns youtube_video_id when given a valid youtube link' do
      video = build(:video, youtube_video_id: valid_youtube_link)
      video.valid?
      expect(video.youtube_video_id).to eq('sampleID91011')
    end

    it 'does not modify youtube_video_id when given an invalid link' do
      video = build(:video, youtube_video_id: invalid_link)
      video.valid?
      expect(video.youtube_video_id).to eq(invalid_link)
    end
  end

  describe 'tags' do
    let(:allowed_tags) { ["焚き火", "森林", "洞窟", "川", "雨", "海", "夜", "海中"] }

    it 'is valid with allowed tags' do
      video = build(:video, tag_list: allowed_tags.sample(3), user: user)
      expect(video).to be_valid
    end

    it 'is invalid with tags that are not allowed' do
      video = build(:video, tag_list: ['NotAllowedTag'])
      expect(video).not_to be_valid
      expect(video.errors[:tag_list]).to include("に不正なタグが含まれています")
    end
  end
end
