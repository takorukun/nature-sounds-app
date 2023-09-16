require 'rails_helper'

RSpec.describe "Top_page", type: :system, js: true do
  let(:user) { create(:user) }

  def resize_window_to_mobile
    page.driver.browser.manage.window.resize_to(360, 640)
  end

  def resize_window_to_desktop
    page.driver.browser.manage.window.resize_to(1024, 768)
  end

  context 'when not logged in' do
    before do
      visit root_path
    end

    describe "on desktop view" do
      before { resize_window_to_desktop }

      it "has expected contents" do
        expect(page).to have_content("ログイン")
        expect(page).to have_content("新規登録")
      end

      it "navigates to home when home button is clicked" do
        expect(page).to have_css('img[alt="Home Button"]')
        find('img[alt="Home Button"]', visible: true).click
        expect(current_path).to eq root_path
      end
    end

    describe "on mobile view" do
      before { resize_window_to_mobile }

      it "shows the dropdown" do
        expect(page).to have_selector('.dropdown')
      end

      it "has login and signup options in the dropdown" do
        find('.dropdown').click
        expect(page).to have_selector('.dropdown', text: 'ログイン')
        expect(page).to have_selector('.dropdown', text: '新規登録')
      end
    end

    it "navigates to login page when login button is clicked" do
      click_on 'ログイン'
      sleep 2
      expect(current_path).to eq new_user_session_path
    end

    it "navigates to signup page when signup button is clicked" do
      click_on '新規登録'
      sleep 2
      expect(current_path).to eq new_user_registration_path
    end
  end

  context 'when logged in' do
    before do
      sign_in user
      visit root_path
    end

    describe "on desktop view" do
      before { resize_window_to_desktop }

      it "has expected contents" do
        expect(page).to have_content("プロフィール")
        expect(page).to have_content("ログアウト")
      end

      it "navigates to profile page when profile button is clicked" do
        click_on 'プロフィール'
        sleep 2
        expect(current_path).to eq user_path(user)
      end

      it "logs out when logout button is clicked" do
        click_on 'ログアウト'
        expect(current_path).to eq root_path
        expect(page).to have_content("ログイン")
        expect(page).to have_content("新規登録")
      end
    end

    describe "on mobile view" do
      before { resize_window_to_mobile }

      it "shows the dropdown" do
        expect(page).to have_selector('.dropdown')
      end

      it "has profile and logout options in the dropdown" do
        find('.dropdown').click
        expect(page).to have_selector('.dropdown', text: 'プロフィール')
        expect(page).to have_selector('.dropdown', text: 'ログアウト')
      end
    end
  end
end
