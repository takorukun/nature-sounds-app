class RemoveUserIdFromPurposeOfMeditations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :purpose_of_meditations, :user, index: true, foreign_key: true
  end
end
