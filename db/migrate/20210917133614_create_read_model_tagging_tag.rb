class CreateReadModelTaggingTag < ActiveRecord::Migration[6.1]
  def change
    create_table :read_model_tagging_tags, id: :uuid do |t|
      t.references :photo, index: true, type: :uuid, foreign_key: { to_table: :read_model_tagging_photos }
      t.string :name, null: false
      t.string :source, null: false
      t.string :provider
      t.timestamp :added_at
    end
  end
end
