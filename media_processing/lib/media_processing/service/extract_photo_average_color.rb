module MediaProcessing
  module Service
    class ExtractPhotoAverageColor
      def initialize(event_store: Rails.configuration.event_store)
        @event_store = event_store
      end

      def call(uid, path)
        rgb = (1..3).map { rand(0..255) }

        event_store.publish(MediaProcessing::Event::PhotoAverageColorExtracted.strict(data: {
          uid: uid,
          rgb: rgb
        }))
      end

      private

      attr_reader :event_store
    end
  end
end
