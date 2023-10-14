require 'rails_helper'

RSpec.describe 'User Registrations', type: :system do

  context 'new registration' do
    before do
      visit new_user_registration_path
      @guest_user = User.guest
    end

    it 'allows user to register' do
      fill_in 'user_name', with: 'Test User'
      fill_in 'user_email', with: 'test@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'

      click_button('新規登録')

      expect(page).to have_content('新規登録しました。')
      expect(page).to have_content('Test User')
      expect(page).to have_content('test@example.com')
    end

    it 'disallows user to register if dont fill in email and password' do
      fill_in 'user_name', with: 'Test User'

      click_button('新規登録')

      expect(page).to have_content("ユーザー が保存できませんでした。2 つのエラーがあります。\nメールアドレスを入力してください パスワードを入力してください")
    end

    it 'transitioning log_in_page if click ログインへ移る' do
      click_link('ログインへ移る')

      expect(current_path).to eq new_user_session_path
    end

    it 'shift to guest mode if click ゲストログイン' do
      click_link('ゲストログイン')

      expect(page).to have_content('ゲストユーザーとしてログインしました。')

      visit user_path(@guest_user)

      expect(page).to have_content('guest@example.com')
    end
  end

  context 'edit registration' do
    let(:user) { create(:user) }

    before do
      @guest_user = User.guest
    end

    it 'allows user to update if fill in each item' do
      login_as(user, scope: :user)

      visit edit_user_registration_path

      fill_in 'user_name', with: 'user'
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'password1'
      fill_in 'user_password_confirmation', with: 'password1'
      fill_in 'user_current_password', with: 'password'
      attach_file 'user_avatar', "#{Rails.root}/spec/fixtures/dummy_image2.jpg"

      click_on("更新する")

      expect(page).to have_content('プロフィールの更新に成功しました。')

      newly_created_user = User.last
      visit user_path(newly_created_user)


      expect(page).to have_content('user')
      expect(page).to have_content('user@example.com')
      user.reload
      expect(user.avatar.filename.to_s).to eq('dummy_image2.jpg')
    end

    it 'allows user to update if not upload image' do
      login_as(user, scope: :user)

      visit edit_user_registration_path

      fill_in 'user_name', with: 'user'
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'password1'
      fill_in 'user_password_confirmation', with: 'password1'
      fill_in 'user_current_password', with: 'password'

      click_on("更新する")

      expect(page).to have_content('プロフィールの更新に成功しました。')

      newly_created_user = User.last
      visit user_path(newly_created_user)


      expect(page).to have_content('user')
      expect(page).to have_content('user@example.com')
      expect(user.avatar.filename.to_s).to eq('dummy_image1.jpg')
    end

    it 'allows user to update if not fill in password and password_confirmation' do
      login_as(user, scope: :user)

      visit edit_user_registration_path

      fill_in 'user_name', with: 'user'
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_current_password', with: 'password'

      click_on("更新する")

      expect(page).to have_content('プロフィールの更新に成功しました。')

      newly_created_user = User.last
      visit user_path(newly_created_user)


      expect(page).to have_content('user')
      expect(page).to have_content('user@example.com')
    end

    it 'disallows user to update if dont fill in current password' do
      login_as(user, scope: :user)

      visit edit_user_registration_path

      click_on("更新する")

      expect(page).to have_content('ユーザー が保存できませんでした。')
      expect(page).to have_content('1 つのエラーがあります。')
      expect(page).to have_content('現在のパスワードを入力してください')
    end

    it 'disallows guest_user to update' do
      login_as(@guest_user, scope: :user)

      visit edit_user_registration_path(@guest_user)

      click_on("更新する")

      expect(page).to have_content('ゲストユーザーの再設定はできません。')
    end

    it 'back if user click on 戻る' do
      login_as(user, scope: :user)

      visit edit_user_registration_path

      click_link("戻る")

      expect(current_path).to eq user_path(user)
    end
  end
end
