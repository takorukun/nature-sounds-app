require 'rails_helper'

RSpec.describe 'Video show page', type: :system do
  let(:user) { create(:user) }
  let(:video) do
    create(:video, user: user, title: 'Sample Video Title', description: 'This is a sample video.', tag_list: '焚き火, 森林')
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
    visit video_path(video)
  end

  it 'displays the embedded YouTube video' do
    expect(page).to have_css("iframe[src='https://www.youtube.com/embed/#{video.youtube_video_id}']")
  end

  it 'displays the video title' do
    expect(page).to have_content('Sample Video Title')
  end

  it 'displays the video description' do
    expect(page).to have_content('This is a sample video.')
  end

  it 'displays the video published at' do
    expect(page).to have_content('2023/10/22')
  end

  it 'displays the video view count' do
    expect(page).to have_content('1,000 views')
  end

  it 'displays the associated tags' do
    video.tag_list.each do |tag|
      expect(page).to have_link(href: videos_path(q: { tags_name_cont_any: [tag] }))
    end
  end

  context 'visit video_pth from videos_path' do
    let!(:videos) do
      (1..3).map do |i|
        create(:video, title: "Sample Video #{i}", description: 'This is a sample video.', tag_list: '焚き火, 森林', user: user)
      end
    end
    before do
      visit videos_path
      click_link('Sample Video 1')
    end

    it 'has a link to go back' do
      click_link('戻る')
      expect(current_path).to eq(videos_path)
    end
  end
end
