require 'rails_helper'

RSpec.describe 'New Video Form', type: :system do
  let(:user) { create(:user) }
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

  before do
    youtube_api_key = ENV['YOUTUBE_API_KEY']

    stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=ijjgofdgf&key=#{youtube_api_key}&part=snippet,statistics").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip,deflate',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'unknown/0.0.0 google-api-ruby-client/0.11.1 Linux/5.15.49-linuxkit-pr (gzip)',
          'X-Goog-Api-Client'=>'gl-ruby/3.0.5 gdcl/1.11.1'
        }).
      to_return(status: 200, body: mocked_response.to_json, headers: { 'Content-Type' => 'application/json' })
    sign_in user
    visit new_video_path
  end

  context 'when submitting valid data' do
    it 'creates a new video' do
      fill_in '動画URL', with: 'https://www.youtube.com/watch?v=ijjgofdgf'
      fill_in '動画タイトル', with: 'Sample Video Title'
      fill_in '動画説明', with: 'This is a test description for the video.'

      check '焚き火'
      check '森林'

      click_button '投稿'

      expect(page).to have_css("iframe[src='https://www.youtube.com/embed/ijjgofdgf']")
      expect(page).to have_content('Sample Video Title')
      expect(page).to have_content('2023/10/22')
      expect(page).to have_content('1,000 views')
      expect(Video.last.tag_list).to include('焚き火', '森林')
    end
  end

  context 'when submitting invalid data' do
    it 'displays error messages' do
      fill_in '動画URL', with: ''
      fill_in '動画タイトル', with: ''
      click_button '投稿'

      expect(page).to have_content('Youtube URLを入力してください')
      expect(page).to have_content('タイトルを入力してください')
    end
  end

  context 'when selecting tags' do
    it 'saves the selected tags' do
      fill_in '動画URL', with: 'https://www.youtube.com/watch?v=ijjgofdgf'
      fill_in '動画タイトル', with: 'Sample Video Title'
      
      ["焚き火", "森林", "洞窟"].each_with_index do |tag, index|
        check "tag_#{index}"
      end

      click_button '投稿'

      expect(Video.last.tag_list).to include('焚き火', '森林', '洞窟')
    end
  end
end
