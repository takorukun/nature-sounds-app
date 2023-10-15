require 'rails_helper'

RSpec.describe 'User Sessions', type: :system do
  describe 'new session' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    it 'allows user to session' do
      puts user.email

      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'password'

      click_button('ログイン')

      expect(page).to have_content('user@example.com')
    end

    it 'disallows user to session if not fill in email' do
      fill_in 'user_password', with: 'password'

      click_button('ログイン')

      expect(page).to have_content("無効な メールアドレス もしくは パスワードです。")
    end

    it 'disallows user to session if not fill in password' do
      fill_in 'user_email', with: 'user@example.com'

      click_button('ログイン')

      expect(page).to have_content("無効な メールアドレス もしくは パスワードです。")
    end

    it 'transitioning sign_up_page if click ログインへ移る' do
      click_link('新規登録へ移る')

      expect(current_path).to eq new_user_registration_path
    end

    it 'shift to guest mode if click ゲストログイン' do
      @guest_user = User.guest

      click_link('ゲストログイン')

      expect(page).to have_content("ゲストユーザーとしてログインしました。")

      visit user_path(@guest_user)

      expect(page).to have_content('guest@example.com')
    end
  end
end
