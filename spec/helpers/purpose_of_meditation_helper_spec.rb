require 'rails_helper'

RSpec.describe PurposeOfMeditationHelper, type: :helper do
  let(:user) { create(:user) }
  let(:video) { create(:video, user: user) }
  let(:start_date) { 17.weeks.ago }
  let(:end_date) { 1.weeks.ago }
  describe 'meets_meditation_requirements?' do
    context 'when the user meets the meditation requirements' do
      before do
        (start_date.to_date..end_date).each_slice(7) do |week|
          6.times do |i|
            create(:meditation, user: user, video: video, date: week.first + i.days, duration: 20)
          end
        end
      end

      it 'returns true' do
        expect(PurposeOfMeditationHelper.meets_meditation_requirements?(user)).to be true
      end
    end

    context 'when the user does not meet the meditation requirements' do
      before do
        (start_date.to_date..end_date.to_date).each_slice(7) do |week|
          5.times do |i|
            create(:meditation, user: user, video: video, date: week.first + i.days, duration: 20)
          end
        end
      end

      it 'returns false' do
        expect(PurposeOfMeditationHelper.meets_meditation_requirements?(user)).to be false
      end
    end
  end
end