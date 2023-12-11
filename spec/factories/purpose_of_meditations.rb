FactoryBot.define do
  factory :purpose_of_meditation do
    title { "MyTitle" }
    description { "MyDescription" }
    frequency_per_week { "4" }
    minutes_per_session { "5" }
    total_duration_weeks { "8" }
  end
end
