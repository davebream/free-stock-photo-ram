module Review
  class Photo < ApplicationRecord
    self.table_name = 'read_model_review_photos'

    def published?
      publish_at.present?
    end
  end
end
