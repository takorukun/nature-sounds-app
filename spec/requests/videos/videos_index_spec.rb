require 'rails_helper'

RSpec.describe "Videos", type: :request do
  let(:user) { create(:user) }
  let(:video_id) { "test_video_id" }
  let(:video) { create(:video, user: user, youtube_video_id: video_id) }
  let!(:videos) { create_list(:video, 10, user: user) }
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

  describe "GET /index" do
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

      get videos_path, params: params
    end

    let(:params) { {} }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "displays video thumbnail, title, view_count, published_at and tags correctly" do
      videos.each do |video|
        expect(response.body).to include(video.youtube_video_id)
        expect(response.body).to include(video.title)
        expect(response.body).to include("1,000 views")
        video.tag_list.each do |tag|
          expect(response.body).to include(tag)
        end
      end
    end

    it "displays the search form and checkboxes for tags" do
      expect(response.body).to include("動画タイトルで検索")
      tags.each do |tag|
        expect(response.body).to include(tag)
      end
    end

    it "displays the 'back' button" do
      expect(response.body).to include("戻る")
    end

    context "when searching by title" do
      let(:params) { { q: { title_cont: "UniqueTitle" } } }
      let!(:specific_video) { create(:video, title: "UniqueTitle12345", user: user) }

      it "displays only videos with the searched title" do
        expect(response.body).to include("UniqueTitle")
        expect(response.body).not_to include("UniqueTitle12345")
      end
    end

    context "when searching by single tag" do
      let(:params) { { q: { tags_name_cont_any: ["海"] } } }
      let!(:video_with_fire_and_sea) { create(:video, tag_list: ["焚き火, 海"], title: "海の近くで焚き火", user: user) }
      let!(:video_with_fire) { create(:video, tag_list: ["焚き火"], title: "火おこし", user: user) }

      it "filters videos by the selected tag" do
        get videos_path, params: params
        expect(response.body).to include(video_with_fire_and_sea.title)
        expect(response.body).not_to include(video_with_fire.title)
      end

      it "displays the searched tags" do
        get videos_path, params: params
        params[:q][:tags_name_cont_any].each do |tag|
          expect(response.body).to include(tag)
        end
      end
    end

    context "when searching by multiple tags" do
      let(:params) { { q: { tags_name_cont_any: ["焚き火", "海"] } } }
      let!(:video_with_fire_and_sea) { create(:video, tag_list: ["焚き火", "海"], title: "海の近くで焚き火", user: user) }
      let!(:video_with_fire) { create(:video, tag_list: ["焚き火"], title: "火おこし", user: user) }

      it "filters videos by multiple tags" do
        get videos_path, params: params
        expect(response.body).to include(video_with_fire_and_sea.title)
        expect(response.body).to include(video_with_fire.title)
      end

      it "displays the searched tags" do
        get videos_path, params: params
        params[:q][:tags_name_cont_any].each do |tag|
          expect(response.body).to include(tag)
        end
      end
    end
  end
end
