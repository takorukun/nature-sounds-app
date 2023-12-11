FactoryBot.define do
  factory :user do
    name { "henderson" }
    email { "user@example.com" }
    password { "password" }
    association :purpose_of_meditation, factory: :purpose_of_meditation
  end

  factory :guest_user, class: 'User' do
    name { "ゲスト" }
    email { "guest@example.com" }
    password { "password" }
    association :purpose_of_meditation, factory: :purpose_of_meditation
  end
end
