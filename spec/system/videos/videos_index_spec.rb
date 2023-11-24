require 'rails_helper'

RSpec.describe 'Videos index page', type: :system do
  describe 'get /videos/index' do
    let(:user) { create(:user) }
    let!(:videos) do
      [
        create(:video, title: "Sample Video 1", user: user),
        create(:video, title: "Sample Video 2", user: user),
        create(:video, title: "Sample Video 3", user: user),
      ]
    end
    let!(:tags) { ["焚き火", "森林", "洞窟"] }
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

      videos.each_with_index do |video, index|
        video.tag_list.add(tags[index])
        video.save
      end

      visit videos_path
    end

    it "displays the page title" do
      expect(page).to have_content("投稿一覧")
    end

    it "allows searching by title" do
      fill_in 'q[title_cont]', with: videos.first.title
      click_on '検索'
      expect(page).to have_content(videos.first.title)
      expect(page).not_to have_content(videos.second.title)
      expect(page).not_to have_content(videos.third.title)
    end

    it "allows filtering by tags" do
      check "tag_0"
      click_on '検索'
      expect(page).to have_content(videos.first.title)
      expect(page).not_to have_content(videos.second.title)
      expect(page).not_to have_content(videos.third.title)
    end

    it "displays searched tags above the results" do
      check "tag_0"
      click_on '検索'
      expect(page).to have_content("検索されたタグ: 焚き火")
    end

    it "displays video details correctly" do
      videos.each_with_index do |video, index|
        within all('.video-item')[index] do
          expect(page).to have_css("iframe[src*='#{video.youtube_video_id}']")
          title_element = find('h3 .text-xl')
          expect(title_element).to have_content(video.title)

          video.tag_list.each do |tag|
            expect(page).to have_content(tag)
          end
        end
      end
    end

    it "navigates to the video show page when title is clicked" do
      within all('.video-item')[0] do
        click_on videos.first.title
      end
      expect(page).to have_current_path(video_path(videos.first))
    end

    it 'when back button is clicked transition to root path' do
      visit root_path
      click_button("検索")
      expect(page).to have_content("みんなの投稿一覧")
      click_link("戻る")
      expect(page).to have_current_path(root_path)
    end

    context 'when user log in' do
      let!(:favorites) do
        videos.map { |video| create(:favorite, user: user, video: video) }
      end

      before do
        sign_in user
        videos.each_with_index do |video, index|
          video.tag_list.add(tags[index])
          video.save
        end
        visit videos_path
      end

      it 'display button to go to the meditation page' do
        videos.each_with_index do |video, index|
          within all('.video-item')[index] do
            expect(page).to have_link(href: meditate_meditations_path(video_id: video.id))
          end
        end
      end

      it 'displays a button to add or remove from favorites for each video' do
        favorites.each_with_index do |favorite, index|
          within all('.video-item')[index] do
            if favorite.user == user
              expect(page).to have_button('お気に入りから削除', disabled: false)
            else
              expect(page).to have_button('お気に入りに追加', disabled: false)
            end
          end
        end
      end
    end
  end
end
