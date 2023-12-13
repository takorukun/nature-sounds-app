module PurposeOfMeditationHelper
  def self.meets_meditation_requirements?(user)
    end_date = Time.zone.now
    start_date = end_date - 16.weeks

    meditation_sessions = Meditation.sessions_for_user(user, start_date, end_date)

    weekly_sessions = meditation_sessions.group_by { |session| session.date.beginning_of_week }
    
    weekly_sessions.all? do |week, sessions|
      sessions.count >= 6 && sessions.sum(&:duration) >= 20 * 6
    end
  end
end