require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user_meeting_requirements) { create(:user, email: "user_meeting_#{rand(1000)}@example.com", purpose_of_meditation_id: 3) }
  let!(:user_not_meeting_requirements) do
    create(:user, email: "user_meeting_#{rand(1000)}@example.com", purpose_of_meditation_id: 3)
  end
  let(:user) { create(:user) }
  let(:video) { create(:video, user: user) }

  before do
    # 条件を満たすユーザーの瞑想セッションを作成
    (1..48).each do |week|
      start_of_week = (Date.today - week.weeks).beginning_of_week
      7.times do |day|
        create(:meditation, user: user_meeting_requirements, video: video, duration: 30, date: start_of_week + day.days)
      end
    end

    # 条件を満たさないユーザーの瞑想セッションを作成
    create_list(:meditation, 10, user: user_not_meeting_requirements, video: video, duration: 30, date: 30.days.ago)
  end

  describe '.users_meeting_purpose_requirements' do
    it 'returns users who meet the specific meditation requirements' do
      expect(User.users_meeting_purpose_requirements(3, 7, 30, 48)).to include(user_meeting_requirements)
      expect(User.users_meeting_purpose_requirements(3, 7, 30, 48)).not_to include(user_not_meeting_requirements)
    end
  end

  describe "validations" do
    it "requires an email" do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "requires a unique email" do
      FactoryBot.create(:user, email: "test@example.com")
      user = FactoryBot.build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end

    it "requires a password when being created" do
      user = FactoryBot.build(:user, password: nil)
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "can have an attached avatar" do
      user = FactoryBot.create(:user)
      user.avatar.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'dummy_image1.jpg')), filename: 'dummy_image1.jpg',
                         content_type: 'image/jpeg')
      expect(user.avatar).to be_attached
    end
  end

  describe ".guest" do
    it "returns a user with the email 'guest@example.com'" do
      user = User.guest
      expect(user.email).to eq('guest@example.com')
    end

    it "creates a new guest user if one does not exist" do
      expect { User.guest }.to change(User, :count).by(1)
    end

    it "does not create a new guest user if one already exists" do
      User.guest
      expect { User.guest }.not_to change(User, :count)
    end
  end
end
