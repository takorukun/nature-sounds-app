require 'rails_helper'

RSpec.describe "Maditation/new", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:video) { create(:video, user: user) }
  let(:other_user) { create(:user, email: 'other@gmail.com') }
  let!(:other_user_video) { create(:video, youtube_video_id: 'other_video_id', user: other_user) }
  let(:meditation) { create(:meditation, user: user, video: video) }
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

  def return_today_string
    today = DateTime.now.day
    today.to_s
  end

  describe 'Creating a new meditation with user_video' do
    let(:today_string) { return_today_string }

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
      visit new_meditation_path(video_id: video.id)
    end

    context 'with valid input' do
      it 'if fill in valid infomation, visit user page and reflected in calendar' do
        fill_in '瞑想時間', with: '40'
        fill_in '日付', with: DateTime.now
        fill_in '記録', with: 'a'

        expect do
          click_button "記録"
          expect(page).to have_current_path(user_path(user))
        end.to change(Meditation, :count).by(1)

        click_button(today_string)
        expect(page).to have_content(today_string + "日の記録")
        expect(page).to have_content('40')
        expect(page).to have_content('a')
        expect(page).to have_content('瞑想に使用した動画')
        expect(page).to have_content('編集')
        expect(page).to have_content('削除')
        expect(page).to have_link("瞑想に使用した動画", href: video_path(video.id))
      end

      it 'Post can be made even on dates already registered' do
        fill_in '瞑想時間', with: '40'
        fill_in '日付', with: DateTime.now
        fill_in '記録', with: 'a'

        expect do
          click_button "記録"
          expect(page).to have_current_path(user_path(user))
        end.to change(Meditation, :count).by(1)

        click_button(today_string)
        expect(page).to have_content(today_string + "日の記録")
        expect(page).to have_content('40')
        expect(page).to have_content('a')
        expect(page).to have_content('瞑想に使用した動画')
        expect(page).to have_content('編集')
        expect(page).to have_content('削除')
        expect(page).to have_link("瞑想に使用した動画", href: video_path(video.id))
      end

      it 'allows creating meditation records with different videos on the same date' do
        sign_in user
        visit new_meditation_path(video_id: video.id)

        fill_in '瞑想時間', with: '40'
        fill_in '日付', with: DateTime.now
        fill_in '記録', with: 'a'
        click_button "記録"

        expect(page).to have_current_path(user_path(user))
        expect(Meditation.count).to eq 1

        visit new_meditation_path(video_id: other_user_video.id)
        fill_in '瞑想時間', with: '30'
        fill_in '日付', with: DateTime.now
        fill_in '記録', with: 'b'
        click_button "記録"

        expect(page).to have_current_path(user_path(user))
        expect(Meditation.count).to eq 2

        click_button(today_string)
        expect(page).to have_content(today_string + "日の記録")
        expect(page).to have_content('40')
        expect(page).to have_content('a')
        expect(page).to have_content('編集')
        expect(page).to have_content('削除')

        expect(page).to have_link("瞑想に使用した動画", href: video_path(video.id))

        expect(page).to have_content('30')
        expect(page).to have_content('b')
        expect(page).to have_link("瞑想に使用した動画", href: video_path(other_user_video.id))
      end
    end

    context 'with invalid input' do
      it 'does not create a meditation and shows an error message' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: ''
        fill_in '記録', with: ''

        expect do
          click_button '記録'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(new_meditation_path(video_id: video.id))
        expect(page).to have_text('瞑想記録を更新できませんでした。瞑想時間を入力してください, 日付を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: DateTime.new(2023, 11, 4)
        fill_in '記録', with: 'a'

        expect do
          click_button '記録'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(new_meditation_path(video_id: video.id))
        expect(page).to have_text('瞑想記録を更新できませんでした。瞑想時間を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: '40'
        fill_in '日付', with: ''
        fill_in '記録', with: 'a'

        expect do
          click_button '記録'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(new_meditation_path(video_id: video.id))
        expect(page).to have_text('瞑想記録を更新できませんでした。日付を入力してください')
      end
    end

    context 'transitioning meditate_meditations_page if click 戻る' do
      it 'transition meditate_meditations_path' do
        execute_script('window.scrollBy(0,10000)')

        click_link "戻る"

        sleep 2

        expect(page).to have_current_path(meditate_meditations_path(video_id: video.id))
        expect(page).to have_content('Sample Video Title')
        expect(page).to have_content('1,000 views')
        expect(page).to have_content('2023/10/22')
      end
    end
  end

  describe 'Creating a new meditation with other_user_video' do
    let(:today_string) { return_today_string }

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
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      visit new_meditation_path(video_id: other_user_video.id)
    end

    context 'with valid input' do
      it 'if fill in valid infomation, visit user page and reflected in calendar' do
        fill_in 'meditation_duration', with: '40'
        fill_in 'meditation_date', with: DateTime.now
        fill_in 'meditation_notes', with: 'a'

        expect do
          click_button "記録"
          expect(page).to have_current_path(user_path(user))
        end.to change(Meditation, :count).by(1)

        click_button(today_string)
        expect(page).to have_content(today_string + "日の記録")
        expect(page).to have_content('40')
        expect(page).to have_content('a')
        expect(page).to have_content('瞑想に使用した動画')
        expect(page).to have_content('編集')
        expect(page).to have_content('削除')
        expect(page).to have_link("瞑想に使用した動画", href: video_path(other_user_video.id))
      end
    end

    context 'with invalid input' do
      it 'does not create a meditation and shows an error message' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: ''
        fill_in '記録', with: ''

        expect do
          click_button '記録'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(new_meditation_path(video_id: other_user_video.id))
        expect(page).to have_text('瞑想記録を更新できませんでした。瞑想時間を入力してください, 日付を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: DateTime.new(2023, 11, 4)
        fill_in '記録', with: 'a'

        expect do
          click_button '記録'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(new_meditation_path(video_id: other_user_video.id))
        expect(page).to have_text('瞑想記録を更新できませんでした。瞑想時間を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: '40'
        fill_in '日付', with: ''
        fill_in '記録', with: 'a'

        expect do
          click_button '記録'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(new_meditation_path(video_id: other_user_video.id))
        expect(page).to have_text('瞑想記録を更新できませんでした。日付を入力してください')
      end
    end

    context 'transitioning meditate_meditations_page if click 戻る' do
      it 'transition meditate_meditations_path' do
        execute_script('window.scrollBy(0,10000)')

        click_link "戻る"

        sleep 2

        expect(page).to have_current_path(meditate_meditations_path(video_id: other_user_video.id))
        expect(page).to have_content('Sample Video Title')
        expect(page).to have_content('1,000 views')
        expect(page).to have_content('2023/10/22')
      end
    end
  end
end
