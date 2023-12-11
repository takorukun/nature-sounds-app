class AddPurposeOfMeditationIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :purpose_of_meditation_id, :bigint
  end
end
