require 'rails_helper'

RSpec.describe "Videos", type: :request do
  let(:user) { create(:user) }
  let(:video) { create(:video, user: user) }
  let(:tags) { ["焚き火", "森林", "洞窟", "川", "雨", "海", "夜", "海中"] }

  describe "GET /edit" do
    before do
      login_as(user, scope: :user)
      get edit_video_path(video)
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "displays the posting form and checkboxes for tags" do
      expect(response.body).to include(video.youtube_video_id)
      expect(response.body).to include(video.title)
      expect(response.body).to include(video.description)
      expect(response.body).to include("更新")
      tags.each do |tag|
        expect(response.body).to include(tag)
      end
    end

    it "displays the 'back' button" do
      expect(response.body).to include("戻る")
    end
  end
end
