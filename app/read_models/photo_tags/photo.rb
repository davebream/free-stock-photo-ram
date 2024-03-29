module PhotoTags
  class Photo < ApplicationRecord
    self.table_name = 'read_model_tags_photos'

    has_many :tags

    scope :tagged, -> { where.not(last_tagging_at: nil) }
    scope :with_file, -> { where.not(filename: nil) }
  end
end
