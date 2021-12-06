class Configuration
  def call(event_store, command_bus)
    event_store.subscribe_to_all_events(RailsEventStore::LinkByEventType.new)
    event_store.subscribe_to_all_events(RailsEventStore::LinkByCorrelationId.new)
    event_store.subscribe_to_all_events(RailsEventStore::LinkByMetadata.new(event_store: event_store, key: :user_id))
    event_store.subscribe_to_all_events(RailsEventStore::LinkByMetadata.new(event_store: event_store, key: :user_email))

    cqrs = CQRS.new(event_store, command_bus)

    # READ MODELS

    Review::Configuration.new(cqrs).call
    PhotoTags::Configuration.new(cqrs).call
    Tags::Configuration.new(cqrs).call
    Uploads::Configuration.new(cqrs).call

    # BOUNDED CONTEXTS

    FileProcessing::Configuration.new(cqrs).call
    Tagging::Configuration.new(cqrs).call
    Reviewing::Configuration.new(cqrs).call
    Publishing::Configuration.new(cqrs).call

    # EVENT HANDLERS

    cqrs.subscribe(CopyrightChecking::Worker::Search, [::Uploading::ImageUploaded])
    cqrs.subscribe(FileProcessing::Worker::ExtractAverageColor, [::Uploading::ImageUploaded])
    cqrs.subscribe(FileProcessing::Worker::RecognizeDimensions, [::Uploading::ImageUploaded])

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::AssignFilename.new(photo_id: event.data.fetch(:image_id), filename: event.data.fetch(:filename)))
      end,
      [Uploading::ImageUploaded]
    )

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::RequestAutoTagging.new(photo_id: event.data.fetch(:photo_id)))
      end,
      [Reviewing::PhotoApproved]
    )

    # PROCESS MANAGERS

    cqrs.subscribe(
      ImageProcessing.new(cqrs),
      [
        FileProcessing::DimensionsRecognized,
        FileProcessing::AverageColorExtracted
      ]
    )

    cqrs.subscribe(
      PhotoPublishing.new(cqrs),
      [
        FileProcessing::ProcessingFinished,
        CopyrightChecking::Found,
        CopyrightChecking::NotFound,
        Reviewing::PhotoRejected,
        Reviewing::PhotoPreApproved,
        Reviewing::PhotoApproved,
        Publishing::PhotoPublished,
        Publishing::PhotoUnpublished
      ]
    )
  end
end
