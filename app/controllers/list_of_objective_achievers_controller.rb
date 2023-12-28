class ListOfObjectiveAchieversController < UsersController
  def purpose_of_meditation_3
    @selected_users = User.users_meeting_purpose_requirements(3, 7, 30, 48)
    @purpose_of_meditation_3 = PurposeOfMeditation.find(3)
    @purpose_of_meditation_4 = PurposeOfMeditation.find(4)
  end

  def purpose_of_meditation_4
    @selected_users = User.users_meeting_purpose_requirements(4, 7, 60, 96)
    @purpose_of_meditation_3 = PurposeOfMeditation.find(3)
    @purpose_of_meditation_4 = PurposeOfMeditation.find(4)
  end
end
