module ImageProcessing
  module Worker
    class ExtractAverageColor
      include Sidekiq::Worker

      def perform(uid, path)
        sleep (8..20).to_a.sample

        rgb = (1..3).map { rand(0..255) }

        Rails.configuration.event_store.publish(ImageProcessing::Event::AverageColorExtracted.new(data: {
          uid: uid,
          rgb: rgb
        }))
      end
    end
  end
end
