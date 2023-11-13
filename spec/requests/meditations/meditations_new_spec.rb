require 'rails_helper'

RSpec.describe "Meditations", type: :request do
  describe "GET /new" do
    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }

    before do
      login_as user
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      get new_meditation_path, params: { video_id: video.id }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "displays the posting form" do
      expect(response.body).to include("瞑想時間を入力してください：分単位")
      expect(response.body).to include("日付")
      expect(response.body).to include("瞑想前と比べてどのような変化を感じたかを記録してみましょう。")
      expect(response.body).to include("記録")
      expect(response.body).to include("戻る")
    end
  end
end
