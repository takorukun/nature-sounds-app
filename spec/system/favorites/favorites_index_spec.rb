require 'rails_helper'

RSpec.describe 'Favorites index page', type: :system do
  let(:user) { create(:user) }
  let!(:videos) do
    [
      create(:video, title: "Sample Video 1", user: user),
      create(:video, title: "Sample Video 2", user: user),
      create(:video, title: "Sample Video 3", user: user),
    ]
  end
  let!(:favorites) do
    videos.map { |video| create(:favorite, user: user, video: video) }
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
    visit favorites_path
  end

  it 'displays the page title' do
    expect(page).to have_content("#{user.name}さんのお気に入り一覧")
  end

  it 'displays all favorites in the list' do
    favorites.each_with_index do |favorite, index|
      within all('.video-item')[index] do
        expect(page).to have_content(favorite.video.title)
        expect(page).to have_css("iframe[src='https://www.youtube.com/embed/#{favorite.video.youtube_video_id}']")
        expect(page).to have_link(href: meditate_meditations_path(video_id: favorite.video.id))
      end
    end
  end

  it 'allows navigation to video show page' do
    first_favorite = favorites.first
    click_link first_favorite.video.title
    expect(current_path).to eq(video_path(first_favorite.video))
  end

  it 'allows removing a video from favorites' do
    favorites.each do |favorite|
      find('.video-item', match: :first).click_button('お気に入りから削除')
      visit favorites_path
      expect(page).not_to have_content(favorite.video.title)
    end
  end
end
