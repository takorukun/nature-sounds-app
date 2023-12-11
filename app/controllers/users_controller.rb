class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @meditations = @user.meditations
    @calendar_events = @meditations.map do |m|
      { id: m.id, duration: m.duration, date: m.date, notes: m.notes, created_at: m.created_at, video_id: m.video_id }
    end
    @meditations_this_week = UserService.count_meditations_this_week(@calendar_events)
    @reclaiming_the_habits = UserService.count_reclaiming_the_habit_of_meditation(@calendar_events)
    @selected_purpose = @user.purpose_of_meditation
  end
end
