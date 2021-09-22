module CopyrightChecking
  module Worker
    class Search
      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::CorrelatedHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        event_klass = [Event::Found, Event::NotFound].sample

        event_store.publish(
          event_klass.new(data: { photo_id: event.data.fetch(:photo_id) })
        )
      end
    end
  end
end
