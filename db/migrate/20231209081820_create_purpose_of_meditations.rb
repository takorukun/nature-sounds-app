class CreatePurposeOfMeditations < ActiveRecord::Migration[7.0]
  def change
    create_table :purpose_of_meditations do |t|
      t.string :title
      t.text :description
      t.integer :frequency_per_week
      t.integer :minutes_per_session
      t.integer :total_duration_weeks
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
