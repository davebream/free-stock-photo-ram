class CreateReadModelReviewingPhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :read_model_review_photos, id: :uuid do |t|
      t.string :filename
      t.string :status
      t.string :copyright
      t.timestamp :uploaded_at
      t.timestamp :publish_at

      t.timestamps
    end
  end
end
