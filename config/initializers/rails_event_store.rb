require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  # Subscribe event handlers below
  Rails.configuration.event_store.tap do |store|
    store.subscribe(->(event) { Media::Medium.call(event) }, to: Media::Medium::EVENTS)
    store.subscribe(MediaProcessing::EventHandler::OnPhotoUploaded.new, to: [Uploading::Event::PhotoUploaded])
  #   store.subscribe(->(event) { SendOrderConfirmation.new.call(event) }, to: [OrderSubmitted])
  #   store.subscribe_to_all_events(->(event) { Rails.logger.info(event.type) })

    store.subscribe(
      MediaProcessing::ProcessManager::PhotoProcessing.new(event_store: Rails.configuration.event_store, command_bus: Rails.configuration.command_bus),
        to: [
          Uploading::Event::PhotoUploaded,
          MediaProcessing::Event::PhotoAverageColorExtracted,
          MediaProcessing::Event::PhotoDimensionsRecognized
        ]
    )
  end

  # Register command handlers below
  Rails.configuration.command_bus.tap do |bus|
    bus.register(Curation::Command::RegisterPhoto, Curation::CommandHandler::OnRegisterPhoto.new)
    bus.register(Curation::Command::MarkCopyrightAsNotFound, Curation::CommandHandler::OnMarkCopyrightAsNotFound.new)
    bus.register(Curation::Command::PublishPhoto, Curation::CommandHandler::OnPublishPhoto.new)
  #   bus.register(SubmitOrder,  ->(cmd) { Ordering::OnSubmitOrder.new.call(cmd) })
  end
end
