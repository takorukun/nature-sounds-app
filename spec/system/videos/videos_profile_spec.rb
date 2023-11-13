require 'rails_helper'

RSpec.describe 'Videos profile page', type: :system do
  describe 'get /videos/profile' do
    let(:user) { create(:user) }
    let!(:user_videos) do
      [
        create(:video, title: "Sample Video 1", user: user),
        create(:video, title: "Sample Video 2", user: user),
        create(:video, title: "Sample Video 3", user: user),
      ]
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
      visit profile_videos_path
    end

    it "displays the page title" do
      expect(page).to have_content("投稿一覧")
    end

    it "has link to post a new video" do
      expect(page).to have_link("動画を投稿する", href: new_video_path)
    end

    it "has link to go back" do
      expect(page).to have_link("戻る")
    end

    context "when displaying videos" do
      it "displays the embedded YouTube video" do
        user_videos.each_with_index do |video, index|
          within all('.video-item')[index] do
            expect(page).to have_css("iframe[src='https://www.youtube.com/embed/#{video.youtube_video_id}']")
          end
        end
      end

      it "displays the video title" do
        user_videos.each_with_index do |video, index|
          within all('.video-item')[index] do
            expect(page).to have_content(video.title)
          end
        end
      end

      it "has link to play the video" do
        user_videos.each_with_index do |video, index|
          within all('.video-item')[index] do
            expect(page).to have_link(video.title, href: video_path(video))
          end
        end
      end

      it "has link to edit the video" do
        user_videos.each_with_index do |video, index|
          within all('.video-item')[index] do
            expect(page).to have_link('編集', href: edit_video_path(video))
          end
        end
      end

      it "has link to delete the video" do
        user_videos.each_with_index do |video, index|
          within all('.video-item')[index] do
            expect(page).to have_link('削除', href: video_path(video))
          end
        end
      end
    end
  end
end
