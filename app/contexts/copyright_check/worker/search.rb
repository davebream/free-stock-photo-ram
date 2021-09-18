module CopyrightCheck
  module Worker
    class Search
      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        events = [
          Event::Found.new(data: { image_id: event.data.fetch(:image_id) }),
          Event::NotFound.new(data: { image_id: event.data.fetch(:image_id) })
        ]

        event_store.publish(events.sample)
      end
    end
  end
end
