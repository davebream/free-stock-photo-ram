class CreateReadModelUploadsPhotos< ActiveRecord::Migration[6.1]
  def change
    create_table :read_model_uploads_photos, id: :uuid do |t|
      t.string :filename
      t.string :path
      t.bigint :width
      t.bigint :height
      t.bigint :average_color_red
      t.bigint :average_color_green
      t.bigint :average_color_blue
      t.timestamp :uploaded_at

      t.timestamps
    end
  end
end
