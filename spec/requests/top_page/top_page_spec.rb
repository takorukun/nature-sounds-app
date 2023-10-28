require 'rails_helper'

RSpec.describe "top_page", type: :request do
  let(:user) { create(:user) }

  describe "GET root_path" do
    context "when user is signed in" do
      before do
        sign_in user
        get root_path
      end

      it "displays profile and logout links" do
        expect(response.body).to include(user_path(user))
        expect(response.body).to include(destroy_user_session_path)
      end

      it "does not display login and sign up links" do
        expect(response.body).not_to include(new_user_session_path)
        expect(response.body).not_to include(new_user_registration_path)
      end
    end

    context "when user is not signed in" do
      before { get root_path }

      it "displays login and sign up links" do
        expect(response.body).to include(new_user_session_path)
        expect(response.body).to include(new_user_registration_path)
      end

      it "does not display profile and logout links" do
        expect(response.body).not_to include(user_path(user))
        expect(response.body).not_to include(destroy_user_session_path)
      end
    end
  end

  describe "GET /top_page" do
    let(:tags) { ["焚き火", "森林", "洞窟", "川", "雨", "海", "夜", "海中"] }

    before do
      get root_path
    end

    it "renders the top page" do
      expect(response).to have_http_status(:success)
    end

    it "displays the main text" do
      expect(response.body).to include("Do you meditate? Or do you play nature sounds?")
      expect(response.body).to include("瞑想記録を始めましょう。")
      expect(response.body).to include("ここでは、あなたがありのままでいられる空間を")
      expect(response.body).to include("瞑想する")
      expect(response.body).to include("動画タイトルで検索")
    end

    it "displays the search form" do
      expect(response.body).to include("動画タイトルで検索")
      tags.each do |tag|
        expect(response.body).to include(tag)
      end
    end

    it "displays Listen Now for each tags" do
      expect(response.body).to include(videos_path(q: { tags_name_eq: '焚き火' }))
      expect(response.body).to include(videos_path(q: { tags_name_eq: '森林' }))
      expect(response.body).to include(videos_path(q: { tags_name_eq: '洞窟' }))
      expect(response.body).to include(videos_path(q: { tags_name_eq: '川' }))
      expect(response.body).to include(videos_path(q: { tags_name_eq: '雨' }))
      expect(response.body).to include(videos_path(q: { tags_name_eq: '海' }))
      expect(response.body).to include(videos_path(q: { tags_name_eq: '夜' }))
      expect(response.body).to include(videos_path(q: { tags_name_eq: '海中' }))
    end
  end
end
