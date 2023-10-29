class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :youtube_video_id
      t.string :thumbnail_url
      t.string :channel_id
      t.integer :duration
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
