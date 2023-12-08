require 'rails_helper'

RSpec.describe 'User Show Page', type: :system, js: true do
  let(:user) { create(:user) }
  let!(:guest_user) { create(:user, name: 'ゲスト', email: 'guest@example.com') }
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
  let(:today_string) { return_today_string }

  def create_meditation_record(video, duration, notes, date: DateTime.now)
    visit new_meditation_path(video_id: video.id)
    fill_in '瞑想時間', with: duration
    fill_in '日付', with: date
    fill_in '記録', with: notes
    click_button '記録'
  end

  def resize_window_to_mobile
    page.driver.browser.manage.window.resize_to(360, 640)
  end

  def resize_window_to_desktop
    page.driver.browser.manage.window.resize_to(1024, 768)
  end

  def return_today_string
    today = DateTime.now.day
    today.to_s
  end

  before do
    login_as(user, scope: :user)
    allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return(nil)
    visit user_path(user)
  end

  it 'if click on 次月 display next month calendar' do
    click_on '次月'

    expect(page).to have_selector('button.btn.btn-ghost', wait: 10)
  end

  it 'if click on 今日 display this month calendar' do
    click_on '今日'

    expect(page).to have_selector('button.btn.btn-ghost', wait: 10)
  end

  it 'if click on 前月 display previous month calendar' do
    click_on '前月'

    expect(page).to have_selector('button.btn.btn-ghost', wait: 10)
  end

  describe "on desktop view" do
    before { resize_window_to_desktop }

    it 'displays user details' do
      expect(page).to have_content("henderson")
      expect(page).to have_content("user@example.com")
    end

    it 'bottuns have each links and data of meditations' do
      [0, 1, 3, 4].each do |days_after_start_of_week|
        create_meditation_record(
          videos[0],
          '40',
          'MyText',
          date: Date.today.beginning_of_week(:monday) + days_after_start_of_week.days
        )
      end

      expect(page).to have_css("img[src*='default_user_icon_640']")
      expect(page).to have_content("hendersonさんのプロフィールです")
      expect(page).to have_content("user@example.com")
      expect(page).to have_link('投稿一覧へ', href: profile_videos_path(user_id: user.id))
      expect(page).to have_link('瞑想を始める', href: videos_path(user_id: user.id))
      expect(page).to have_link('ユーザー情報編集', href: edit_user_registration_path)
      expect(page).to have_content("前月")
      expect(page).to have_content("今日")
      expect(page).to have_content("次月")
      expect(page).to have_content("今週の瞑想日数")
      expect(page).to have_content("習慣を取り戻した回数\n△2日連続以上を記録すると1回と記録されます")
      expect(page).to have_content("4日")
      expect(page).to have_content("2回")
    end

    context "when guest user is logged in" do
      before do
        login_as guest_user
        allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return(nil)
        visit user_path(guest_user)
      end

      it "displays guest user message" do
        expect(page).to have_css("img[src*='default_user_icon_640']")
        expect(page).to have_content("ゲストさんのプロフィールです")
        expect(page).to have_content("guest@example.com")
        expect(page).to have_link('投稿一覧へ', href: profile_videos_path(user_id: guest_user.id))
        expect(page).to have_link('瞑想を始める', href: videos_path(user_id: guest_user.id))
        expect(page).to have_link('ユーザー情報編集', href: edit_user_registration_path)
      end
    end
  end

  context 'when set the avatar image' do
    before do
      sign_in user
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      visit user_path(user)
    end

    it 'displays the avatar image' do
      expect(page).to have_css("img[src='http://example.com/fake_avatar_url']")
    end
  end

  context 'if not posted' do
    it 'not display a meditation data' do
      click_button('9')

      within('.modal-box') do
        expect(page).to have_content('9日の記録')
        expect(page).not_to have_content('編集')
        expect(page).not_to have_content('削除')

        expect(page).not_to have_link("瞑想に使用した動画", href: video_path(videos[0].id))
      end
    end
  end

  context 'if posted once' do
    it 'display a meditation data' do
      create_meditation_record(videos[0], '40', 'MyText', date: DateTime.now)

      click_button(today_string)

      expect(page).to have_content(today_string + '日の記録')
      expect(page).to have_content('40')
      expect(page).to have_content('MyText')
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')

      expect(page).to have_link("瞑想に使用した動画", href: video_path(videos[0].id))
      expect(page).not_to have_link("瞑想に使用した動画", href: video_path(videos[1].id))
    end
  end

  context 'if posted twice' do
    it 'display two meditation data' do
      create_meditation_record(videos[0], '40', 'MyText')

      create_meditation_record(videos[1], '30', 'AnotherText')

      click_button(today_string)

      expect(page).to have_content(today_string + '日の記録')
      expect(page).to have_content('40')
      expect(page).to have_content('MyText')
      expect(page).to have_content('30')
      expect(page).to have_content('AnotherText')
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')

      expect(page).to have_link("瞑想に使用した動画", href: video_path(videos[0].id))
      expect(page).to have_link("瞑想に使用した動画", href: video_path(videos[1].id))
    end
  end

  describe "on mobile view" do
    before { resize_window_to_mobile }

    it 'bottuns have each links and data of meditations' do
      [0, 1, 3, 4].each do |days_after_start_of_week|
        create_meditation_record(
          videos[0],
          '40',
          'MyText',
          date: Date.today.beginning_of_week(:monday) + days_after_start_of_week.days
        )
      end

      expect(page).to have_css("img[src*='default_user_icon_640']")
      expect(page).to have_content("hendersonさんのプロフィールです")
      expect(page).not_to have_content("user@example.com")
      expect(page).to have_link('投稿一覧へ', href: profile_videos_path(user_id: user.id))
      expect(page).to have_link('瞑想を始める', href: videos_path(user_id: user.id))
      expect(page).to have_link('ユーザー情報編集', href: edit_user_registration_path)
      expect(page).to have_content("前月")
      expect(page).to have_content("今日")
      expect(page).to have_content("次月")
      expect(page).to have_content("今週の瞑想日数")
      expect(page).to have_content("習慣を取り戻した回数\n△2日連続以上を記録すると1回と記録されます")
      expect(page).to have_content("4日")
      expect(page).to have_content("2回")
    end

    context "when guest user is logged in" do
      before do
        login_as guest_user
        allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return(nil)
        visit user_path(guest_user)
      end

      it "displays guest user message" do
        expect(page).to have_css("img[src*='default_user_icon_640']")
        expect(page).to have_content("ゲストさんのプロフィールです")
        expect(page).not_to have_content("guest@example.com")
        expect(page).to have_link('投稿一覧へ', href: profile_videos_path(user_id: guest_user.id))
        expect(page).to have_link('瞑想を始める', href: videos_path(user_id: guest_user.id))
        expect(page).to have_link('ユーザー情報編集', href: edit_user_registration_path)
      end
    end
  end
end
