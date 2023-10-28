class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:profile, :new, :create, :edit, :update, :destroy]

  def index
    @q = Video.includes(:tags).ransack(params[:q])
    @videos = @q.result(distinct: true)
    @tags = ["焚き火", "森林", "洞窟", "川", "雨", "海", "夜", "海中"]
  end

  def show
    @video = Video.includes(:tags).find(params[:id])
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.user = current_user
    @video.youtube_video_id = YoutubeService.extract_youtube_video_id(@video.youtube_video_id)
    if @video.save
      redirect_to @video, notice: '動画の投稿に成功しました。'
    else
      flash[:alert] = '動画の投稿に失敗しました。' + @video.errors.full_messages.join(", ")
      redirect_to new_video_path
    end
  end

  def edit
    @video = Video.find(params[:id])
    @video.youtube_video_id = 'https://www.youtube.com/watch?v=' + @video.youtube_video_id
  end

  def update
    @video = Video.find(params[:id])
    updated_params = video_params.merge(
      youtube_video_id: YoutubeService.extract_youtube_video_id(video_params[:youtube_video_id])
    )
    if @video.update(updated_params)
      redirect_to @video, notice: '動画の更新に成功しました。'
    else
      flash[:alert] = '動画の更新に失敗しました。' + @video.errors.full_messages.join(", ")
      redirect_to edit_video_path(@video)
    end
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    redirect_to videos_path, notice: '動画の削除に成功しました。'
  end

  def profile
    @user_videos = current_user.videos
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :youtube_video_id, tag_list: [])
  end
end
