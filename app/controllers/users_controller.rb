class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    if @user.avatar.attached?
      key = @user.avatar.blob.key

      s3 = Aws::S3::Resource.new(
        region: ENV['AWS_REGION'] || 'ap-northeast-1',
        credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_ACCESS_KEY'])
      )
      signer = Aws::S3::Presigner.new(client: s3.client)
      @presigned_url = signer.presigned_url(:get_object,
        bucket: 'main-bucket-takorukun', key: key, expires_in: 60)
    end
  end
end
