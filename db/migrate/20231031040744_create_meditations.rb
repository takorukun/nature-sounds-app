class CreateMeditations < ActiveRecord::Migration[7.0]
  def change
    create_table :meditations do |t|
      t.integer :duration
      t.date :date
      t.text :notes
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true

      t.timestamps
    end
  end
end
