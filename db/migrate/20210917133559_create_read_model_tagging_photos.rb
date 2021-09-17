class CreateReadModelTaggingPhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :read_model_tagging_photos, id: :uuid do |t|
      t.string :filename
      t.timestamp :last_tagging_at

      t.timestamps
    end
  end
end
