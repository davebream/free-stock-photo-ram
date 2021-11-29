module FileProcessing
  module Worker
    class RecognizeDimensions
      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::CorrelatedHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        width = 1920
        height = 1080

        event_store.publish(
          FileProcessing::DimensionsRecognized.new(
            data: {
              image_id: event.data.fetch(:image_id),
              width: width,
              height: height
            }
          )
        )
      end
    end
  end
end
