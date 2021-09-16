module CopyrightCheck
  module Worker
    class Search
      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        events = [
          Event::Found.new(data: { uid: event.data.fetch(:uid) }),
          Event::NotFound.new(data: { uid: event.data.fetch(:uid) })
        ]

        event_store.publish(events.sample)
      end
    end
  end
end
