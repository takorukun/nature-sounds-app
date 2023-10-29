class TopPageController < ApplicationController
  def index
    @q = Video.includes(:tags).ransack(params[:q])
    @videos = @q.result(distinct: true)
    @tags = ["焚き火", "森林", "洞窟", "川", "雨", "海", "夜", "海中"]
  end
end
