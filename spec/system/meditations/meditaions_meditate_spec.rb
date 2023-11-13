require 'rails_helper'

RSpec.describe 'Video show page', type: :system do
  let(:user) { create(:user) }
  let(:video) { create(:video, tag_list: '焚き火, 森林', user: user) }
  let(:other_user) { create(:user, email: 'other@gmail.com') }
  let(:other_user_video) { create(:video, youtube_video_id: 'other_video_id', tag_list: '焚き火, 森林', user: other_user) }
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
    visit meditate_meditations_path(video_id: video.id)
  end

  context 'Video posted by myself' do
    it 'displays the embedded YouTube video' do
      expect(page).to have_css("iframe[src='https://www.youtube.com/embed/#{video.youtube_video_id}']")
    end

    it 'displays the video title' do
      expect(page).to have_content('Sample Video Title')
    end

    it 'displays the video published at' do
      expect(page).to have_content('2023/10/22')
    end

    it 'displays the video view count' do
      expect(page).to have_content('1,000 views')
    end

    it 'displays the associated tags' do
      expect(page).to have_content('焚き火')
      expect(page).to have_content('森林')
    end

    it 'navigates to a page and uses the back link to return' do
      visit videos_path

      within all('.video-item')[0] do
        click_link '瞑想を始める'
      end

      click_link '戻る'

      expect(current_path).to eq videos_path
    end

    it 'has a link to go new meditation page' do
      expect(page).to have_link('瞑想記録に移る', href: new_meditation_path(video_id: video.id))
    end
  end

  context 'Video posted by other user' do

    before do
      youtube_api_key = ENV['YOUTUBE_API_KEY']

      stub_request(:get, "https://youtube.googleapis.com/youtube/v3/videos?id=other_video_id&key=#{youtube_api_key}&part=snippet,statistics").
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
      visit meditate_meditations_path(video_id: other_user_video.id)
    end
    
    it 'displays the embedded YouTube video' do
      expect(page).to have_css("iframe[src='https://www.youtube.com/embed/#{other_user_video.youtube_video_id}']")
    end

    it 'displays the video title' do
      expect(page).to have_content('Sample Video Title')
    end

    it 'displays the video published at' do
      expect(page).to have_content('2023/10/22')
    end

    it 'displays the video view count' do
      expect(page).to have_content('1,000 views')
    end

    it 'displays the associated tags' do
      expect(page).to have_content('焚き火')
      expect(page).to have_content('森林')
    end

    it 'navigates to a page and uses the back link to return' do
      visit videos_path

      within all('.video-item')[1] do
        click_link '瞑想を始める'
      end

      click_link '戻る'

      expect(current_path).to eq videos_path
    end

    it 'has a link to go new meditation page' do
      expect(page).to have_link('瞑想記録に移る', href: new_meditation_path(video_id: other_user_video.id))
    end
  end
end
