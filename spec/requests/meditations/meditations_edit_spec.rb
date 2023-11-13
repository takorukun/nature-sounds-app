require 'rails_helper'

RSpec.describe "Meditations", type: :request do
  let(:user) { create(:user) }
  let(:meditation) { create(:meditation, duration: '20', date: '002023-09-01T00:00', user: user, video: video) }
  let(:video) { create(:video, user: user) }

  describe "GET /edit" do
    before do
      sign_in user
      allow_any_instance_of(ApplicationHelper).to receive(:user_avatar_url).and_return('http://example.com/fake_avatar_url')
      get edit_meditation_path(meditation)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "displays the posting form" do
      expect(response.body).to include(meditation.duration.to_s)
      expect(response.body).to include(meditation.date.to_s)
      expect(response.body).to include(meditation.notes)
      expect(response.body).to include("更新")
      expect(response.body).to include("戻る")
    end
  end
end
