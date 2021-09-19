module CopyrightCheck
  module Worker
    class Search
      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        event_klass = [Event::Found, Event::NotFound].sample

        event_store.publish(event_klass.new(
          data: {
            photo_id: event.data.fetch(:photo_id),
            image_id: event.data.fetch(:image_id)
          }
        ))
      end
    end
  end
end
