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

  describe '#user_avatar_url' do
    let(:user) { create(:user) }
    let(:s3_presigner) { instance_double(Aws::S3::Presigner) }

    before do
      allow(Aws::S3::Presigner).to receive(:new).and_return(s3_presigner)
    end

    context 'when the user has an avatar attached' do
      let(:presigned_url) { "https://example.com/presigned-url" }

      before do
        allow(user.avatar).to receive(:attached?).and_return(true)
        allow(user.avatar).to receive(:blob).and_return(OpenStruct.new(key: 'avatar-key'))
        allow(s3_presigner).to receive(:presigned_url).and_return(presigned_url)
      end

      it 'returns a presigned URL' do
        url = helper.user_avatar_url(user)
        expect(url).to eq(presigned_url)
        expect(s3_presigner).to have_received(:presigned_url).with(
          :get_object,
          bucket: ENV.fetch('S3_BUCKET', 'main-bucket-takorukun'),
          key: 'avatar-key',
          expires_in: 60
        )
      end
    end

    context 'when the user does not have an avatar attached' do
      before do
        allow(user.avatar).to receive(:attached?).and_return(false)
      end

      it 'returns nil' do
        expect(helper.user_avatar_url(user)).to be_nil
      end
    end
  end
end
