module UI
  module Tagging
    class OnAutoTagsAdded
      def call(event)
        photo = Photo.find_or_initialize_by(id: event.data.fetch(:photo_id))
        photo.last_tagging_at = event.timestamp
        photo.save

        tags_to_upsert = event.data.fetch(:tags).map do |tag|
          {
            photo_id: event.data.fetch(:photo_id),
            id: tag.fetch(:id),
            name: tag.fetch(:name),
            source: 'external',
            provider: event.data.fetch(:provider),
            added_at: event.timestamp
          }
        end

        Tag.upsert_all(tags_to_upsert) if tags_to_upsert.any?
      end
    end
  end
end
