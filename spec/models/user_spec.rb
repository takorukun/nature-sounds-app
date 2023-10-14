require 'rails_helper'

RSpec.describe User, type: :model do
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
