class RemoveReadModelMedia < ActiveRecord::Migration[6.1]
  def change
    drop_table :read_model_media
  end
end
