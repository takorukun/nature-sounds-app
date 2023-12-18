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

  describe 'method' do
    let(:start_date) { 3.weeks.ago }
    let(:end_date) { Time.zone.now }

    before do
      create(:meditation, user: user, video: video, date: 2.weeks.ago)
      create(:meditation, user: user, video: video, date: 1.week.ago)

      create(:meditation, user: user, video: video, date: 4.weeks.ago)
      create(:meditation, user: create(:user, email: 'other_user@sample.com'), video: video, date: 2.weeks.ago)
    end

    context 'sessions_for_user_method' do
      it 'returns meditations for the specified user within the given date range' do
        result = Meditation.sessions_for_user(user, start_date, end_date)

        expect(result.count).to eq(2)
        expect(result).to all(have_attributes(user_id: user.id))
        expect(result).to all(have_attributes(date: be >= start_date))
        expect(result).to all(have_attributes(date: be <= end_date))
      end
    end
  end
end
