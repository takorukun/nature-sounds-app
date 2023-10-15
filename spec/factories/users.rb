FactoryBot.define do
  factory :user do
    name { "henderson" }
    email { "user@example.com" }
    password { "password" }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'dummy_image1.jpg'), 'image/jpeg') }
  end
end
