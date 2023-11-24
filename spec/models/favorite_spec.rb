require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:video) { create(:video, user: user) }

  describe 'validations' do
    it 'allows a user to favorite a video once' do
      favorite = build(:favorite, user: user, video: video)
      expect(favorite).to be_valid
    end

    it 'does not allow a user to favorite the same video twice' do
      create(:favorite, user: user, video: video)
      duplicate_favorite = user.favorites.build(video: video)
      expect(duplicate_favorite).not_to be_valid
    end
  end
end
