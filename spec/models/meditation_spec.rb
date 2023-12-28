require 'rails_helper'

RSpec.describe Meditation, type: :model do
  let(:user) { create(:user) }
  let(:video) { create(:video, user: user) }
  let(:valid_duration) { '40' }
  let(:meditation) { create(:meditation, user: user, video: video) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      meditation = build(:meditation, duration: valid_duration, date: '2023-11-4', user: user, video: video)
      expect(meditation).to be_valid
    end

    it 'is invalid without a duration' do
      meditation = build(:meditation, duration: nil, date: '2023-11-4', user: user, video: video)
      expect(meditation).not_to be_valid
    end

    it 'is invalid without a date' do
      meditation = build(:meditation, duration: valid_duration, date: nil, user: user, video: video)
      expect(meditation).not_to be_valid
    end

    it 'is invalid with a notes longer than 500 characters' do
      long_notes = 'a' * 501
      meditation = build(:meditation, notes: long_notes, user: user, video: video)
      expect(meditation).not_to be_valid
    end

    it 'is valid with a notes of 500 characters or less' do
      notes = 'a' * 500
      meditation = build(:meditation, notes: notes, user: user, video: video)
      expect(meditation).to be_valid
    end
  end
end
