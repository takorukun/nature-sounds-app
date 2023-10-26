require 'rails_helper'

RSpec.describe "Videos", type: :request do
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
                url: "https://sample/maxres_thumbnail.jpg"
              }
            }
          },
          statistics: {
            viewCount: "1000"
          }
        }
      ]
    }
  end

  describe "GET /show" do
    before do
      youtube_api_key = ENV['YOUTUBE_API_KEY']

      stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=#{video.youtube_video_id}&key=#{youtube_api_key}&part=snippet,statistics")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip,deflate',
            'Content-Type' => 'application/x-www-form-urlencoded',
            'User-Agent' => 'unknown/0.0.0 google-api-ruby-client/0.11.1 Linux/5.15.49-linuxkit-pr (gzip)',
            'X-Goog-Api-Client' => 'gl-ruby/3.0.5 gdcl/1.11.1'
          }
        )
        .to_return(
          status: 200,
          body: mocked_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      get video_path(video)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    context "when the video has a description" do
      let(:video) { create(:video, description: "Sample description", user: user) }
    
      it "displays video thumbnail, title, tags, and description correctly" do
        expect(response.body).to include(video.youtube_video_id)
        expect(response.body).to include(video.title)
        expect(response.body).to include("1,000 views")
        expect(response.body).to include("2023/10/22")
        expect(response.body).to include(video.description)
        video.tag_list.each do |tag|
          expect(response.body).to include(tag)
        end
      end
    end
    
    context "when the video does not have a description" do
      let(:video) { create(:video, description: "", user: user) }
    
      it "displays video thumbnail, title, and tags correctly without description" do
        expect(response.body).to include(video.youtube_video_id)
        expect(response.body).to include(video.title)
        expect(response.body).to include("1,000 views")
        expect(response.body).to include("2023/10/22")
        expect(response.body).not_to include("説明文:")
        video.tag_list.each do |tag|
          expect(response.body).to include(tag)
        end
      end
    end

    it "displays the 'back' button" do
      expect(response.body).to include("戻る")
    end

    context "when single tag" do
      let(:params) { { q: { tags_name_cont_any: ["海"] } } }

      it "displays the searched tags" do
        get videos_path, params: params
        params[:q][:tags_name_cont_any].each do |tag|
          expect(response.body).to include(tag)
        end
      end
    end

    context "when multiple tags" do
      let(:params) { { q: { tags_name_cont_any: ["焚き火", "海"] } } }

      it "displays the searched tags" do
        get videos_path, params: params
        params[:q][:tags_name_cont_any].each do |tag|
          expect(response.body).to include(tag)
        end
      end
    end
  end
end
