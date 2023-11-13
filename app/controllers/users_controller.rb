class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @meditations = @user.meditations
    @calendar_events = @meditations.map do |m|
      { id: m.id, duration: m.duration, date: m.date, notes: m.notes, created_at: m.created_at, video_id: m.video_id }
    end
  end
end
