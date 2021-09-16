module ImageProcessing
  module Worker
    class RecognizeDimensions
      include Sidekiq::Worker

      def perform(uid, path)
        sleep (8..20).to_a.sample

        width = 1920
        height = 1080

        Rails.configuration.event_store.publish(ImageProcessing::Event::DimensionsRecognized.new(data: {
          uid: uid,
          width: width,
          height: height
        }))
      end
    end
  end
end
