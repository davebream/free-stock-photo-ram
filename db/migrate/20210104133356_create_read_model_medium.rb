class CreateReadModelMedium < ActiveRecord::Migration[6.1]
  def change
    create_table :read_model_media, id: :uuid do |t|
      t.string :status
      t.string :copyright
      t.datetime :publish_at

      t.timestamps
    end
  end
end
