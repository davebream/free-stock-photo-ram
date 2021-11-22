module PhotoTags
  class Tag < ApplicationRecord
    self.table_name = 'read_model_tags_tags'

    belongs_to :photo
  end
end
