
module Tagging
  module Worker
    class AutoTagPhoto
      require 'faker'

      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        tags = (1..10).map { Faker::Creature::Animal.name };

        tags = tags.map do |tag|
          { uid: SecureRandom.uuid, name: tag }
        end

        event_store.publish(
          Tagging::Event::AutoTagsGenerated.new(
            data: {
              uid: event.data.fetch(:uid),
              tags: tags,
              provider: 'auto_tagging_provider'
            }
          )
        )
      end
    end
  end
end
