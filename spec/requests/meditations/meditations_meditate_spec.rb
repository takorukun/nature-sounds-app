require 'rails_helper'

RSpec.describe "Meditations", type: :request do
  describe "GET /meditate" do
    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }
    let(:tags) { ["焚き火", "海"] }
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

    before do
      youtube_api_key = ENV['YOUTUBE_API_KEY']

      stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=test_video_id&key=#{youtube_api_key}&part=snippet,statistics").
        with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip,deflate',
            'Content-Type' => 'application/x-www-form-urlencoded',
            'X-Goog-Api-Client' => 'gl-ruby/3.0.5 gdcl/1.11.1',
          }
        ).
        to_return(status: 200, body: mocked_response.to_json, headers: { 'Content-Type' => 'application/json' })

      login_as user
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      get meditate_meditations_path, params: { video_id: video.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "displays video thumbnail, title, views, and tags correctly" do
      expect(response.body).to include(video.youtube_video_id)
      expect(response.body).to include(video.title)
      expect(response.body).to include("1,000 views")
      expect(response.body).to include("2023/10/22")
      video.tag_list.each do |tag|
        expect(response.body).to include(tag)
      end
    end

    it "displays the 'back' button" do
      expect(response.body).to include("戻る")
    end
  end
end