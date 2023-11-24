class FavoritesController < ApplicationController
  before_action :set_video, only: [:create, :destroy]

  def index
    @favorites = current_user.favorites
    @user = current_user
  end

  def create
    favorite = current_user.favorites.new(video_id: @video.id)
    favorite.save
    redirect_to favorites_path, notice: '動画をお気に入りに登録しました。'
  end

  def destroy
    favorite = current_user.favorites.find_by(video_id: @video.id)
    favorite.destroy if favorite
    redirect_to favorites_path, notice: '動画をお気に入りから削除しました。'
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end
end