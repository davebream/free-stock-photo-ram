class Configuration
  def call(event_store, command_bus)
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

    cqrs.subscribe(CopyrightChecking::Worker::Search, [::Uploading::Event::PhotoUploaded])
    cqrs.subscribe(FileProcessing::Worker::ExtractAverageColor, [::Uploading::Event::PhotoUploaded])
    cqrs.subscribe(FileProcessing::Worker::RecognizeDimensions, [::Uploading::Event::PhotoUploaded])

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::Command::AssignFilename.new(photo_id: event.data.fetch(:photo_id), filename: event.data.fetch(:filename)))
      end,
      [Uploading::Event::PhotoUploaded]
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
