require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe "GET /users/sign_in" do
    it "renders the login page" do
      get new_user_session_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("ログイン")
    end
  end

  describe "POST /users/sign_in" do
    let(:user) { create(:user, email: 'test@example.com', password: 'password') }

    context "with valid login details" do
      it "logs the user in" do
        post user_session_path, params: { user: { email: user.email, password: 'password' } }
        allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq("ログインしました。")
      end
    end

    context "with invalid login details" do
      it "does not log the user in" do
        post user_session_path, params: { user: { email: user.email, password: 'wrongpassword' } }
        allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq("無効な メールアドレス もしくは パスワードです。")
      end
    end
  end

  describe "POST /users/guest_sign_in" do
    it "logs the user in as a guest" do
      post users_guest_sign_in_path
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("ゲストユーザーとしてログインしました。")
    end
  end
end
