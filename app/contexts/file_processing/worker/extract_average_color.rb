module FileProcessing
  module Worker
    class ExtractAverageColor
      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        rgb = (1..3).map { rand(0..255) }

        event_store.publish(FileProcessing::Event::AverageColorExtracted.new(data: {
          photo_id: event.data.fetch(:photo_id),
          rgb: rgb
        }))
      end
    end
  end
end
