require 'rails_helper'

RSpec.describe VideosHelper, type: :helper do
  describe '#youtube_thumbnail' do
    before do
      youtube_api_key = ENV['YOUTUBE_API_KEY']

      stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=test_video_id&key=#{youtube_api_key}&part=snippet,statistics").
        with(
          headers: {
            'Accept' => '*/*',
            'X-Goog-Api-Client' => 'gl-ruby/3.0.5 gdcl/1.11.1',
          }
        ).
        to_return(
          status: 200,
          body: mocked_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    context 'when video is found' do
      let(:video_id) { "test_video_id" }
      let(:mocked_response) do
        {
          items: [
            {
              snippet: {
                title: "Sample Video Title",
                publishedAt: "2023-10-22T00:00:00Z",
                thumbnails: {
                  maxres: {
                    url: "https://sample/maxres_thumbnail.jpg",
                  },
                },
              },
              statistics: {
                viewCount: "1000",
              },
            },
          ],
        }
      end

      it 'returns the thumbnail iframe' do
        result = youtube_thumbnail(video_id)
        expect(result).to include("https://www.youtube.com/embed/#{video_id}")
      end

      it 'displays video title' do
        result = youtube_thumbnail(video_id)
        expect(result).to include("Sample Video Title")
      end

      it 'displays video view count' do
        result = youtube_thumbnail(video_id)
        expect(result).to include("1,000 views")
      end

      it 'displays video upload date' do
        result = youtube_thumbnail(video_id, show_info: true)
        expect(result).to include("2023/10/22")
      end

      it 'does not display video information when show_info option is set to false' do
        result = youtube_thumbnail(video_id, show_info: false)
        expect(result).not_to include("Sample Video Title")
        expect(result).not_to include("1,000 views")
        expect(result).not_to include("2023/10/22")
      end

      it 'does not make a second request when data is cached' do
        youtube_thumbnail(video_id)
        expect(WebMock).not_to receive(:request).with(any_args)
        youtube_thumbnail(video_id)
      end
    end

    context 'when video is not found' do
      let(:video_id) { "invalid_video_id" }
      let(:mocked_response) do
        { items: [] }
      end

      before do
        youtube_api_key = ENV['YOUTUBE_API_KEY']

        stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=invalid_video_id&key=#{youtube_api_key}&part=snippet,statistics").
          with(
            headers: {
              'Accept' => '*/*',
              'X-Goog-Api-Client' => 'gl-ruby/3.0.5 gdcl/1.11.1',
            }
          ).
          to_return(
            status: 200,
            body: mocked_response.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns "Video not found" message' do
        result = youtube_thumbnail(video_id)
        expect(result).to include("Video not found")
      end
    end

    context 'when the API request fails' do
      let(:video_id) { "default_video_id" }
      let(:mocked_response) do
        {
          items: [
            {
              snippet: {
                title: "Sample Video Title",
                published_at: "2023-10-22T00:00:00Z",
                thumbnails: {
                  maxres: {
                    url: "https://sample/maxres_thumbnail.jpg",
                  },
                },
              },
              statistics: {
                viewCount: "1000",
              },
            },
          ],
        }
      end

      before do
        youtube_api_key = ENV['YOUTUBE_API_KEY']

        stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=default_video_id&key=#{youtube_api_key}&part=snippet,statistics").
          with(
            headers: {
              'Accept' => '*/*',
              'X-Goog-Api-Client' => 'gl-ruby/3.0.5 gdcl/1.11.1',
            }
          ).
          to_return(
            status: 500,
            body: mocked_response.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns "Video not found" message' do
        result = youtube_thumbnail(video_id)
        expect(result).to include("Video not found")
      end
    end
  end
end
