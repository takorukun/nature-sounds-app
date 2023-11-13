require 'rails_helper'

RSpec.describe "show page", type: :request do
  describe "GET /show" do
    context "when user is logged in" do
      let(:user) { create(:user) }

      before do
        sign_in user
        allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
        get user_path(user)
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "displays the user's name and email" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(user.email)
      end

      it "displays links to the user's videos and edit registration" do
        expect(response.body).to include(profile_videos_path)
        expect(response.body).to include(edit_user_registration_path)
        expect(response.body).to include(videos_path(user_id: user.id))
      end

      it "displays simple calender dates, 前月, 今日, 次月 bottuns" do
        (1..Time.now.end_of_month.day).each do |day|
          expect(response.body).to include("showModal('#{day}')")
        end
        expect(response.body).to include("前月")
        expect(response.body).to include("今日")
        expect(response.body).to include("次月")
      end

      context "application helper returns nil when user is signed in" do
        before do
          sign_in user
          allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return(nil)
          get user_path(user)
        end

        it "displays default icon" do
          expect(response.body).to include('default_user_icon_640')
        end
      end
    end

    context "when guest user is logged in" do
      let(:guest_user) { create(:user, email: 'guest@example.com') }

      before do
        sign_in guest_user
        allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
        get user_path(guest_user)
      end

      it "displays guest user message" do
        expect(response.body).to include("ゲストさんのプロフィールです")
      end
    end
  end
end
