FactoryBot.define do
  factory :video do
    youtube_video_id { "test_video_id" }
    title { "title" }
    description { "description" }
    tag_list { "" }
  end
end
