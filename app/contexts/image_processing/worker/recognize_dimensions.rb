module ImageProcessing
  module Worker
    class RecognizeDimensions
      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        width = 1920
        height = 1080

        event_store.publish(ImageProcessing::Event::DimensionsRecognized.new(data: {
          uid: event.data.fetch(:uid),
          width: width,
          height: height
        }))
      end
    end
  end
end
