require 'rails_helper'

RSpec.describe "registrations", type: :request do
  describe "GET /users/sign_up" do
    it "renders the sign up page" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let(:user_params) do
        { user: { name: "John", email: "john@example.com", password: "password", password_confirmation: "password" } }
      end

      it "creates a new user" do
        expect do
          post user_registration_path, params: user_params
        end.to change(User, :count).by(1)
      end

      it "redirects to the user's show page" do
        post user_registration_path, params: user_params
        user = assigns(:user)
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "with invalid parameters" do
      let(:user_params) do
        { user: { name: "john", email: "", password: "", password_confirmation: "" } }
      end

      it "does not create a new user" do
        expect do
          post user_registration_path, params: user_params
        end.not_to change(User, :count)
      end

      it "renders the new template with error messages" do
        post user_registration_path, params: user_params
        expect(response.body).to include("メールアドレスを入力してください")
        expect(response.body).to include("パスワードを入力してください")
      end
    end
  end

  describe "User Profile Update" do
    let(:user) { create(:user) }
    let(:valid_params) do
      {
        user: {
          name: "Updated Name",
          email: "updated@example.com",
          current_password: user.password,
          password: "newpassword",
          password_confirmation: "newpassword",
        },
      }
    end

    before do
      sign_in user
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      get edit_user_registration_path(user)
    end

    it "Each item should be displayed" do
      expect(response.body).to include("名前")
      expect(response.body).to include("メールアドレス")
      expect(response.body).to include("パスワード")
      expect(response.body).to include("確認用パスワード")
      expect(response.body).to include("現在のパスワード")
      expect(response.body).to include("アイコン画像")
      expect(response.body).to include("瞑想の目的")
      expect(response.body).to include("MyTitle</br> 改善されること: MyDescription")
    end

    context "sign_in guest_user" do
      let(:guest_user) { create(:guest_user) }

      before do
        sign_in guest_user
        get edit_user_registration_path(guest_user)
      end

      it "Only a description of the purpose of the meditation should be only displayed" do
        expect(response.body).not_to include("名前")
        expect(response.body).not_to include("メールアドレス")
        expect(response.body).not_to include("パスワード")
        expect(response.body).not_to include("確認用パスワード")
        expect(response.body).not_to include("現在のパスワード")
        expect(response.body).not_to include("アイコン画像")
        expect(response.body).to include("瞑想の目的")
        expect(response.body).to include("MyTitle</br> 改善されること: MyDescription")
      end
    end

    context "with valid data" do
      it "updates the user profile" do
        put user_registration_path, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(user.reload.name).to eq("Updated Name")
        expect(user.reload.email).to eq("updated@example.com")
      end
    end

    context "with invalid email" do
      it "does not update and shows error" do
        put user_registration_path, params: { user: { name: "Updated Name", email: "", current_password: user.password } }
        expect(response.body).to include("メールアドレスを入力してください")
      end
    end

    context "with invalid current password" do
      it "does not update and shows error" do
        put user_registration_path,
        params: { user: { name: "Updated Name", email: "updated@example.com", current_password: "wrongpassword" } }
        expect(response.body).to include("現在のパスワードは不正な値です")
      end
    end
  end
end
