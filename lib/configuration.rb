class Configuration
  def call(event_store, command_bus)
    event_store.subscribe_to_all_events(RailsEventStore::LinkByEventType.new)
    event_store.subscribe_to_all_events(RailsEventStore::LinkByCorrelationId.new)
    event_store.subscribe_to_all_events(RailsEventStore::LinkByMetadata.new(event_store: event_store, key: :user_id))
    event_store.subscribe_to_all_events(RailsEventStore::LinkByMetadata.new(event_store: event_store, key: :user_email))

    cqrs = CQRS.new(event_store, command_bus)

    # READ MODELS

    Review::Configuration.new(cqrs).call
    Tags::Configuration.new(cqrs).call
    Uploads::Configuration.new(cqrs).call

    # BOUNDED CONTEXTS

    FileProcessing::Configuration.new(cqrs).call
    Tagging::Configuration.new(cqrs).call
    Reviewing::Configuration.new(cqrs).call
    Publishing::Configuration.new(cqrs).call

    # EVENT HANDLERS

    cqrs.subscribe(CopyrightChecking::Worker::Search, [::Uploading::Event::ImageUploaded])
    cqrs.subscribe(FileProcessing::Worker::ExtractAverageColor, [::Uploading::Event::ImageUploaded])
    cqrs.subscribe(FileProcessing::Worker::RecognizeDimensions, [::Uploading::Event::ImageUploaded])

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::Command::AssignFilename.new(photo_id: event.correlation_id, filename: event.data.fetch(:filename)))
      end,
      [Uploading::Event::ImageUploaded]
    )

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::Command::RequestAutoTagging.new(photo_id: event.data.fetch(:photo_id)))
      end,
      [Reviewing::PhotoApproved]
    )

    # PROCESS MANAGERS

    cqrs.subscribe(
      ImageProcessing.new(event_store, command_bus),
      [
        FileProcessing::Event::DimensionsRecognized,
        FileProcessing::Event::AverageColorExtracted
      ]
    )

    cqrs.subscribe(
      PhotoPublishing.new(event_store, command_bus),
      [
        FileProcessing::Event::ProcessingFinished,
        CopyrightChecking::Event::Found,
        CopyrightChecking::Event::NotFound,
        Reviewing::PhotoRejected,
        Reviewing::PhotoPreApproved,
        Reviewing::PhotoApproved,
        Publishing::Event::PhotoPublished,
        Publishing::Event::PhotoUnpublished
      ]
    )
  end
end
