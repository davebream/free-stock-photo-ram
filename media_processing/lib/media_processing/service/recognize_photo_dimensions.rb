module MediaProcessing
  module Service
    class RecognizePhotoDimensions
      def initialize(event_store: Rails.configuration.event_store)
        @event_store = event_store
      end

      def call(uid, path)
        width = 1920
        height = 1080

        event_store.publish(MediaProcessing::Event::PhotoDimensionsRecognized.strict(data: {
          uid: uid,
          width: width,
          height: height
        }))
      end

      private

      attr_reader :event_store
    end
  end
end
