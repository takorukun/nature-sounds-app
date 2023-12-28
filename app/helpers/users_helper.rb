module UsersHelper
  def self.count_meditations_this_week(events)
    start_of_week = Time.zone.now.beginning_of_week(:monday)
    end_of_week = start_of_week + 6.days

    events.count { |event| event[:date] >= start_of_week && event[:date] <= end_of_week }
  end

  def self.count_reclaiming_the_habit_of_meditation(events)
    sorted_events = events.sort_by { |event| event[:date] }
    count = 0
    streak = 0

    sorted_events.each_with_index do |event, index|
      if index == 0
        streak = 1
        next
      end

      if event[:date] == sorted_events[index - 1][:date] + 1.day
        streak += 1
      else
        count += 1 if streak >= 2
        streak = 1
      end
    end

    count += 1 if streak >= 2
    count
  end
end
