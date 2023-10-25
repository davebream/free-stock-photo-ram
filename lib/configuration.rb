class Configuration
  def call(cqrs)
    [
      RailsEventStore::LinkByEventType.new,
      RailsEventStore::LinkByCorrelationId.new,
      RailsEventStore::LinkByCausationId.new,
      RailsEventStore::LinkByMetadata.new(event_store: cqrs.event_store, key: :user_id),
      RailsEventStore::LinkByMetadata.new(event_store: cqrs.event_store, key: :user_email),
      LinkByPhotoId.new(cqrs)
    ].each { |h| cqrs.subscribe_to_all_events(h) }

    ###
    # READ MODELS
    ###

    Review::Configuration.new(cqrs).call
    PhotoTags::Configuration.new(cqrs).call
    Tags::Configuration.new(cqrs).call
    Uploads::Configuration.new(cqrs).call

    ###
    # BOUNDED CONTEXTS
    ###

    FileProcessing::Configuration.new(cqrs).call
    Tagging::Configuration.new(cqrs).call
    Reviewing::Configuration.new(cqrs).call
    Publishing::Configuration.new(cqrs).call

    ###
    # EVENT HANDLERS
    ###

    cqrs.subscribe(CopyrightChecking::Worker::Search, [::Uploading::ImageUploaded])
    cqrs.subscribe(FileProcessing::Worker::ExtractAverageColor, [::Uploading::ImageUploaded])
    cqrs.subscribe(FileProcessing::Worker::RecognizeDimensions, [::Uploading::ImageUploaded])

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::AssignFilename.new(photo_id: event.data.fetch(:photo_id), filename: event.data.fetch(:filename)))
      end,
      [Uploading::ImageUploaded]
    )

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::RequestAutoTagging.new(photo_id: event.data.fetch(:photo_id)))
      end,
      [Reviewing::PhotoApproved]
    )

    ###
    # PROCESS MANAGERS
    ###

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
