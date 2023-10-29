require 'rails_helper'

RSpec.describe "Videos", type: :request do
  let(:user) { create(:user) }
  let(:video) { create(:video, user: user) }
  let!(:videos) { create_list(:video, 10, user: user) }
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

  describe "GET /profile" do
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

      login_as(user, scope: :user)
      get profile_videos_path
    end

    let(:params) { {} }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "displays '投稿一覧'" do
      expect(response.body).to include("投稿一覧")
    end

    it "displays video thumbnail, title, view_count, published_at and tags correctly" do
      videos.each do |video|
        expect(response.body).to include(video.youtube_video_id)
        expect(response.body).to include(video.title)
        expect(response.body).to include("1,000 views")
      end
    end

    it "displays each buttons" do
      expect(response.body).to include("戻る")
      expect(response.body).to include("動画を投稿する")
      expect(response.body).to include("編集")
      expect(response.body).to include("削除")
    end
  end

  describe "GET /profile without login" do
    it "redirects to the login page" do
      get profile_videos_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /profile with another user's videos" do
    let(:other_email) { "other@example.com" }
    let(:other_user) { create(:user, email: other_email) }
    let!(:other_user_videos) { create_list(:video, 5, youtube_video_id: other_user_youtube_video_id, user: other_user) }
    let(:other_user_youtube_video_id) { "otherid" }
    let(:mocked_response_for_other_user) do
      {
        items: [
          {
            snippet: {
              title: "Other User Video Title",
              publishedAt: "2023-10-23T00:00:00Z",
              thumbnails: {
                maxres: {
                  url: "https://sample/other_user_maxres_thumbnail.jpg",
                },
              },
            },
            statistics: {
              viewCount: "500",
            },
          },
        ],
      }
    end

    before do
      youtube_api_key = ENV['YOUTUBE_API_KEY']

      other_user_videos.each do |video|
        stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=#{video.youtube_video_id}&key=#{youtube_api_key}&part=snippet,statistics").
          with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip,deflate',
              'Content-Type' => 'application/x-www-form-urlencoded',
              'X-Goog-Api-Client' => 'gl-ruby/3.0.5 gdcl/1.11.1',
            }
          ).
          to_return(status: 200, body: mocked_response_for_other_user.to_json, headers: { 'Content-Type' => 'application/json' })
      end

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

      login_as(user, scope: :user)
      get profile_videos_path
    end

    it "does not display other user's videos" do
      other_user_videos.each do |video|
        expect(response.body).not_to include("Other User Video Title")
      end
    end
  end

  describe "GET /profile without videos" do
    let!(:videos) { [] }

    before do
      login_as(user, scope: :user)
      get profile_videos_path
    end

    it "displays a message indicating no videos" do
      expect(response.body).not_to include(video.youtube_video_id)
      expect(response.body).not_to include("Sample Video Title")
    end
  end
end
