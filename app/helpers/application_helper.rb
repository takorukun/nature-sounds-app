module ApplicationHelper
  def user_avatar_url(user)
    return nil unless user.avatar.attached?

    key = user.avatar.blob.key
    s3 = Aws::S3::Resource.new(
      region: ENV['AWS_REGION'] || 'ap-northeast-1',
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    )
    signer = Aws::S3::Presigner.new(client: s3.client)
    signer.presigned_url(:get_object, bucket: 'main-bucket-takorukun', key: key, expires_in: 60)
  end

  def random_background_image
    backgrounds = Dir.glob("app/assets/images/bg-images_1280/*").map do |path|
      File.basename(path)
    end
    "bg-images_1280/#{backgrounds.sample}"
  end
end
