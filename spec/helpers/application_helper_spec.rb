require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#random_background_image" do
    it "returns a random image path from 'app/assets/images/bg-images_1280/' directory" do
      image_path = helper.random_background_image
      expect(image_path).to start_with('bg-images_1280/')
      
      actual_path = Rails.root.join('app', 'assets', 'images', image_path)
      expect(File).to exist(actual_path)
    end
  end
end
