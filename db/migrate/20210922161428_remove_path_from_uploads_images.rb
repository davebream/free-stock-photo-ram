class RemovePathFromUploadsImages < ActiveRecord::Migration[6.1]
  def change
    remove_column :read_model_uploads_images, :path
  end
end
