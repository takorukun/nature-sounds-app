require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:video_id) { "test_video_id" }
  let(:video) { create(:video, user: user, youtube_video_id: video_id) }
  let!(:videos) { create_list(:video, 10, user: user, youtube_video_id: video_id, tag_list: '焚き火, 夜') }
  let(:favorites) do
    videos.map do |video|
      create(:favorite, user: user, video: video)
    end
  end
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

    sign_in user
    allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
    get favorites_path
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end

  it "displays 'user.nameさんのお気に入り一覧'" do
    expect(response.body).to include(user.name + "さんのお気に入り一覧")
  end

  it "displays all favorites in the list" do
    user.favorites.each do |favorite|
      expect(response.body).to include(favorite.video.title)
      expect(response.body).to include(youtube_thumbnail(favorite.video.youtube_video_id))
      expect(response.body).to include("1,000 views")
      expect(response.body).to include("瞑想を始める")
      expect(response.body).to include("お気に入りから削除")
      favorite.video.tag_list.each do |tag|
        expect(response.body).to include(tag)
      end
    end
  end

  it "displays the 'back' button" do
    expect(response.body).to include("戻る")
  end

  context 'sign in as a guest' do
    let(:guest_user) { create(:user, name: 'ゲスト', email: 'guest@gmail.com') }

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

      sign_in guest_user
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      get favorites_path
    end

    it "displays 'ゲストさんのお気に入り一覧'" do
      expect(response.body).to include("ゲストさんのお気に入り一覧")
    end
  end
end