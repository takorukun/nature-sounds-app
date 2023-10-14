require 'rails_helper'

RSpec.describe 'User Show Page', type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
    visit user_path(user)
  end

  it 'displays user details' do
    expect(page).to have_content("henderson")
    expect(page).to have_content("user@example.com")
  end
end
