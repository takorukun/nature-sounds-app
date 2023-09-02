module ApplicationHelper
  def random_background_image
    backgrounds = Dir.glob("app/assets/images/bg-images_1280/*").map do |path|
      File.basename(path)
    end
    "bg-images_1280/#{backgrounds.sample}"
  end
end
