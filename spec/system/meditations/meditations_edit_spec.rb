require 'rails_helper'

RSpec.describe "Meditation/edit", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:video) { create(:video, user: user) }
  let(:other_user) { create(:user, email: 'other@gmail.com') }
  let!(:other_user_video) { create(:video, youtube_video_id: 'other_video_id', user: other_user) }
  let(:meditation) { create(:meditation, user: user, video: video) }
  let(:other_meditation) { create(:meditation, user: user, video: other_user_video) }
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
      visit edit_meditation_path(meditation)
    end

    it 'forms have informations' do
      expect(page).to have_field('瞑想時間', with: '1')
      expect(page).to have_field('日付', with: '2023-11-10')
      expect(page).to have_field('記録', with: 'MyText')
    end

    context 'with invalid input' do
      it 'does not create a meditation and shows an error message' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: ''
        fill_in '記録', with: ''

        expect do
          click_button '更新'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(edit_meditation_path(meditation))
        expect(page).to have_text('瞑想記録の更新に失敗しました。瞑想時間を入力してください, 日付を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: DateTime.now
        fill_in '記録', with: 'a'

        expect do
          click_button '更新'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(edit_meditation_path(meditation))
        expect(page).to have_text('瞑想記録の更新に失敗しました。瞑想時間を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: '40'
        fill_in '日付', with: ''
        fill_in '記録', with: 'a'

        expect do
          click_button '更新'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(edit_meditation_path(meditation))
        expect(page).to have_text('瞑想記録の更新に失敗しました。日付を入力してください')
      end
    end

    context 'transitioning meditate_meditations_page if click 戻る' do
      it 'transition meditate_meditations_path' do
        execute_script('window.scrollBy(0,10000)')

        click_link "戻る"

        sleep 2

        expect(page).to have_current_path(user_path(user))
      end
    end
  end

  describe 'Creating a new meditation with other_user_video' do
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
      visit edit_meditation_path(other_meditation)
    end

    it 'forms have informations' do
      expect(page).to have_field('瞑想時間', with: '1')
      expect(page).to have_field('日付', with: '2023-11-10')
      expect(page).to have_field('記録', with: 'MyText')
    end

    context 'with invalid input' do
      it 'does not create a meditation and shows an error message' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: ''
        fill_in '記録', with: ''

        expect do
          click_button '更新'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(edit_meditation_path(other_meditation))
        expect(page).to have_text('瞑想記録の更新に失敗しました。瞑想時間を入力してください, 日付を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: ''
        fill_in '日付', with: DateTime.now
        fill_in '記録', with: 'a'

        expect do
          click_button '更新'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(edit_meditation_path(other_meditation))
        expect(page).to have_text('瞑想記録の更新に失敗しました。瞑想時間を入力してください')
      end

      it 'does not create a meditation and shows an error message when user not fill in duration' do
        fill_in '瞑想時間', with: '40'
        fill_in '日付', with: ''
        fill_in '記録', with: 'a'

        expect do
          click_button '更新'
        end.not_to change(Meditation, :count)

        sleep 2

        execute_script('window.scrollBy(0, -10000)')

        expect(page).to have_current_path(edit_meditation_path(other_meditation))
        expect(page).to have_text('瞑想記録の更新に失敗しました。日付を入力してください')
      end
    end

    context 'transitioning meditate_meditations_page if click 戻る' do
      it 'transition meditate_meditations_path' do
        execute_script('window.scrollBy(0,10000)')

        click_link "戻る"

        sleep 2

        expect(page).to have_current_path(user_path(user))
      end
    end
  end
end
