require 'rails_helper'

RSpec.describe 'User Registrations', type: :system do
  describe 'new registration' do
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

  describe 'edit registration' do
    context 'user' do
      let(:user) { create(:user) }
      let(:purpose_of_meditation) { create(:purpose_of_meditation) }
      let!(:purposes) do
        [
          create(:purpose_of_meditation, title: 'Mytitle1', description: 'Mydescription1'),
          create(:purpose_of_meditation, title: 'Mytitle2', description: 'Mydescription2'),
          create(:purpose_of_meditation, title: 'Mytitle3', description: 'Mydescription3'),
          create(:purpose_of_meditation, title: 'Mytitle4', description: 'Mydescription4'),
        ]
      end

      before do
        login_as(user, scope: :user)
        visit edit_user_registration_path
      end

      it 'allows user to update if fill in each item' do
        fill_in 'user_name', with: 'user'
        fill_in 'user_email', with: 'user@example.com'
        fill_in 'user_password', with: 'password1'
        fill_in 'user_password_confirmation', with: 'password1'
        fill_in 'user_current_password', with: 'password'
        attach_file 'user_avatar', "#{Rails.root}/spec/fixtures/dummy_image2.jpg"
        select 'MyTitle', from: 'user_purpose_of_meditation_id'

        click_on("更新する")

        expect(page).to have_content('プロフィールの更新に成功しました。')

        newly_created_user = User.last
        visit user_path(newly_created_user)

        expect(page).to have_content('user')
        expect(page).to have_content('user@example.com')
        user.reload
        expect(user.avatar.filename.to_s).to eq('dummy_image2.jpg')
        expect(page).to have_content("MyTitle\n0日\n0回\nMyDescription\n実践方法: 1週間の内4日、 1日の中で5分、瞑想を行いましょう 期間: 8週間")
      end

      it 'allows user to update if not upload image' do
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
      end

      it 'allows user to update if not fill in password and password_confirmation' do
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
        click_on("更新する")

        expect(page).to have_content('ユーザー が保存できませんでした。')
        expect(page).to have_content('1 つのエラーがあります。')
        expect(page).to have_content('現在のパスワードを入力してください')
      end

      it 'back if user click on 戻る' do
        click_link("戻る")

        expect(current_path).to eq user_path(user)
      end

      context 'when user meets meditation requirements' do
        before do
          allow(PurposeOfMeditationHelper).to receive(:meets_meditation_requirements?).and_return(true)
        end

        it 'displays all meditation purposes in the select box' do
          expect(page).to have_select('user_purpose_of_meditation_id', with_options: purposes.map(&:title))
        end
      end

      context 'when user does not meet meditation requirements' do
        before do
          allow(PurposeOfMeditationHelper).to receive(:meets_meditation_requirements?).and_return(false)
        end

        it 'displays limited meditation purposes in the select box' do
          expect(page).to have_select('user_purpose_of_meditation_id', with_options: purposes.first(2).map(&:title))
        end
      end

      it 'displays all meditation purposes and their descriptions' do
        purposes.each do |purpose|
          expect(page).to have_content(purpose.title)
          expect(page).to have_content(purpose.description)
        end
      end
    end

    context 'guest_user' do
      let(:guest_user) { create(:guest_user) }
      let(:purpose_of_meditation) { create(:purpose_of_meditation) }

      it 'allows guest_user to update' do
        login_as(guest_user, scope: :user)
        visit edit_user_registration_path

        select 'MyTitle', from: 'user_purpose_of_meditation_id'

        click_on("更新する")

        expect(page).to have_content('プロフィールの更新に成功しました')

        visit user_path(guest_user)

        expect(page).to have_content("MyTitle\n0日\n0回\nMyDescription\n実践方法: 1週間の内4日、 1日の中で5分、瞑想を行いましょう 期間: 8週間")
      end
    end
  end
end
