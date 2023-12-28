require 'rails_helper'

RSpec.describe UsersHelper do
  describe '.count_meditations_this_week' do
    let(:start_of_week) { Date.today.beginning_of_week(:monday) }
    let(:end_of_week) { start_of_week + 6.days }

    it 'counts the number of events this week correctly' do
      events_this_week = [
        { date: start_of_week },
        { date: start_of_week + 3.days },
        { date: end_of_week },
      ]

      events_last_week = [{ date: start_of_week - 7.days }]
      events_next_week = [{ date: end_of_week + 1.day }]

      all_events = events_this_week + events_last_week + events_next_week

      expect(UsersHelper.count_meditations_this_week(all_events)).to eq(3)
    end
  end

  describe '.count_reclaiming_the_habit_of_meditation' do
    let(:start_of_week) { Date.today.beginning_of_week(:monday) }

    context 'When continued for 3 consecutive days' do
      it 'counts the number of events correctly' do
        sorted_events = [
          { date: start_of_week },
          { date: start_of_week + 2.days },
          { date: start_of_week + 3.days },
        ]

        expect(UsersHelper.count_reclaiming_the_habit_of_meditation(sorted_events)).to eq(1)
      end
    end

    context 'When recorded two days at a time with one day open' do
      it 'counts the number of events correctly' do
        sorted_events = [
          { date: start_of_week },
          { date: start_of_week + 1.days },
          { date: start_of_week + 4.days },
          { date: start_of_week + 5.days },
        ]

        expect(UsersHelper.count_reclaiming_the_habit_of_meditation(sorted_events)).to eq(2)
      end
    end
  end
end
