FactoryBot.define do
  factory :meditation do
    duration { 1 }
    date { DateTime.new(2023, 11, 10) }
    notes { "MyText" }
    user { nil }
    video { nil }
  end
end
