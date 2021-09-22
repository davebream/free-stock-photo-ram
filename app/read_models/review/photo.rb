module Review
  class Photo < ApplicationRecord
    self.table_name = 'read_model_review_photos'

    def published?
      publish_at.present?
    end

    def self.set_status(id, status)
      set_attribute(id, :status, status)
    end

    def self.set_copyright(id, status)
      set_attribute(id, :copyright, status)
    end

    def self.set_attribute(id, attribute, value)
      photo = find_or_initialize_by(id: id)
      photo[attribute] = value
      photo.save!
    end
  end
end
