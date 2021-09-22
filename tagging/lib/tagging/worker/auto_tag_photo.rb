module Tagging
  module Worker
    class AutoTagPhoto
      require 'faker'

      include FreeStockPhotoWorker

      prepend MetadataHandler
      prepend RailsEventStore::CorrelatedHandler
      prepend RailsEventStore::AsyncHandler

      def perform(event)
        sleep_random

        tags = (1..10).map { Faker::Creature::Animal.name }

        tags = tags.map do |tag|
          { id: SecureRandom.uuid, name: tag }
        end

        event_store.publish(
          Tagging::Event::AutoTagsGenerated.new(
            data: {
              photo_id: event.data.fetch(:photo_id),
              tags: tags,
              provider: 'auto_tagging_provider'
            }
          )
        )
      end
    end
  end
end
