require 'rails_helper'

RSpec.describe YoutubeService do
  describe '.extract_youtube_video_id' do
    context 'when the link is from youtu.be' do
      let(:link) { 'https://youtu.be/sampleID1234' }

      it 'extracts the video id correctly' do
        expect(YoutubeService.extract_youtube_video_id(link)).to eq('sampleID1234')
      end
    end

    context 'when the link is a full YouTube URL' do
      let(:link) { 'https://www.youtube.com/watch?v=sampleID5678&feature=related' }

      it 'extracts the video id correctly' do
        expect(YoutubeService.extract_youtube_video_id(link)).to eq('sampleID5678')
      end
    end

    context 'when the link has no query parameters' do
      let(:link) { 'https://www.youtube.com/watch' }

      it 'returns nil' do
        expect(YoutubeService.extract_youtube_video_id(link)).to be_nil
      end
    end

    context 'when the link is nil' do
      let(:link) { nil }

      it 'returns nil' do
        expect(YoutubeService.extract_youtube_video_id(link)).to be_nil
      end
    end

    context 'when the link is from a different domain' do
      let(:link) { 'https://www.example.com/watch?v=sampleID91011' }

      it 'returns nil' do
        expect(YoutubeService.extract_youtube_video_id(link)).to be_nil
      end
    end
  end
end
