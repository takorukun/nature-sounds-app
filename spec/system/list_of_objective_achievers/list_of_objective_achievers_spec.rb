require 'rails_helper'

RSpec.describe "ListOfObjectiveAchievers", type: :system do
  describe "GET /purpose_of_meditation_3" do
    let(:user_meeting_requirements) { create(:user, name: 'user', purpose_of_meditation_id: 3) }
    let(:not_objective_achiever) { create(:user, name: 'other_user', email: 'other@sample.com') }
    let(:video) { create(:video, user: user_meeting_requirements) }

    let(:purpose_of_meditation_3) do
      create(:purpose_of_meditation,
        id: 3, title: "本格的に始めたい",
        description: "MyDescription",
        frequency_per_week: 7,
        minutes_per_session: 30,
        total_duration_weeks: 48)
    end
    let(:purpose_of_meditation_4) do
      create(:purpose_of_meditation,
        id: 4, title: "修行",
        description: "MyDescription",
        frequency_per_week: 7,
        minutes_per_session: 60,
        total_duration_weeks: 96)
    end

    before do
      (1..48).each do |week|
        7.times do |day|
          create(:meditation, user: user_meeting_requirements, video: video, duration: 30,
                              date: (Date.today - week.weeks).beginning_of_week + day.days)
        end
      end
      login_as(user_meeting_requirements)
      @purpose_of_meditation_3 = purpose_of_meditation_3
      @purpose_of_meditation_4 = purpose_of_meditation_4
      visit purpose_of_meditation_3_list_of_objective_achievers_path
    end

    it 'display objective achiever in list' do
      expect(page).to have_content('user')
      expect(page).not_to have_content('other_user')
      expect(page).to have_content('高難易度の瞑想習慣の達成者瞑想項目：本格的に始めたい')
    end

    context 'when push the button to transit to purpose of meditation 3 list' do
      it 'display purpose of meditation 3 list' do
        click_link '修行の達成者'

        expect(current_path).to eq(purpose_of_meditation_4_list_of_objective_achievers_path)
        expect(page).not_to have_content('user')
        expect(page).not_to have_content('other_user')
      end
    end
  end
  describe "GET /purpose_of_meditation_4" do
    let(:user_meeting_requirements) { create(:user, name: 'user', purpose_of_meditation_id: 4) }
    let(:not_objective_achiever) { create(:user, name: 'other_user', email: 'other@sample.com') }
    let(:video) { create(:video, user: user_meeting_requirements) }

    let(:purpose_of_meditation_3) do
      create(:purpose_of_meditation,
        id: 3, title: "本格的に始めたい",
        description: "MyDescription",
        frequency_per_week: 7,
        minutes_per_session: 30,
        total_duration_weeks: 48)
    end
    let(:purpose_of_meditation_4) do
      create(:purpose_of_meditation,
        id: 4,
        title: "修行",
        description: "MyDescription",
        frequency_per_week: 7,
        minutes_per_session: 60,
        total_duration_weeks: 96)
    end

    before do
      (1..96).each do |week|
        7.times do |day|
          create(:meditation, user: user_meeting_requirements, video: video, duration: 60,
                              date: (Date.today - week.weeks).beginning_of_week + day.days)
        end
      end
      login_as(user_meeting_requirements)
      @purpose_of_meditation_3 = purpose_of_meditation_3
      @purpose_of_meditation_4 = purpose_of_meditation_4
      visit purpose_of_meditation_4_list_of_objective_achievers_path
    end

    it 'display objective achiever in list' do
      expect(page).to have_content('user')
      expect(page).not_to have_content('other_user')
      expect(page).to have_content('高難易度の瞑想習慣の達成者瞑想項目：修行')
    end

    context 'when push the button to transit to purpose of meditation 3 list' do
      it 'display purpose of meditation 3 list' do
        click_link '本格的に始めたい'

        expect(current_path).to eq(purpose_of_meditation_3_list_of_objective_achievers_path)
        expect(page).not_to have_content('user')
        expect(page).not_to have_content('other_user')
      end
    end
  end
end
