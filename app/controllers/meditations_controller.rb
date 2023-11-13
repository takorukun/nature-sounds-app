class MeditationsController < ApplicationController
  def new
    @meditation = Meditation.new
    @video = Video.find(params[:video_id])
  end

  def create
    @meditation = Meditation.new(meditation_params)
    @meditation.user = current_user
    @meditation.video_id = params[:meditation][:video_id]
    if @meditation.save
      redirect_to user_path(@meditation.user), notice: '瞑想記録を更新しました。'
    else
      flash[:alert] = '瞑想記録を更新できませんでした。' + @meditation.errors.full_messages.join(", ")
      redirect_to new_meditation_path(video_id: params[:meditation][:video_id])
    end
  end

  def edit
    @meditation = Meditation.find(params[:id])
  end

  def update
    @meditation = Meditation.find(params[:id])
    if @meditation.update(meditation_params)
      redirect_to user_path(@meditation.user), notice: '瞑想記録の更新に成功しました。'
    else
      flash[:alert] = '瞑想記録の更新に失敗しました。' + @meditation.errors.full_messages.join(", ")
      redirect_to edit_meditation_path(@meditation)
    end
  end

  def destroy
    @meditation = Meditation.find(params[:id])
    @meditation.destroy
    redirect_to user_path(@meditation.user), notice: '瞑想記録の削除に成功しました。'
  end

  def meditate
    @video = Video.find(params[:video_id])
  end

  private

  def meditation_params
    params.require(:meditation).permit(:duration, :date, :notes, :video_id)
  end
end
