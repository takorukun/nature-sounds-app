require 'rails_helper'

RSpec.describe "show page", type: :request do
  describe "GET /show" do
    context "when user is logged in" do
      let(:user) { create(:user) }

      before do
        sign_in user
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
      end
    end

    context "when guest user is logged in" do
      let(:guest_user) { create(:user, email: 'guest@example.com') } 

      before do
        sign_in guest_user
        get user_path(guest_user)
      end

      it "displays guest user message" do
        expect(response.body).to include("ゲストさんのプロフィールです")
      end
    end
  end
end
