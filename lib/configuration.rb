# frozen_string_literal: true

class Configuration
  def call(event_store, command_bus)
    cqrs = CQRS.new(event_store, command_bus)

    UI::Review::Photo::Configuration.new(cqrs).call
    UI::Tagging::Photo::Configuration.new(cqrs).call
    UI::Tagging::Tag::Configuration.new(cqrs).call
    UI::Uploads::Photo::Configuration.new(cqrs).call

    FileProcessing::Configuration.new(cqrs).call
    Tagging::Configuration.new(cqrs).call
    Reviewing::Configuration.new(cqrs).call
    Publishing::Configuration.new(cqrs).call

    cqrs.subscribe(CopyrightCheck::Worker::Search, [::Uploading::Event::PhotoUploaded])
    cqrs.subscribe(FileProcessing::Worker::ExtractAverageColor, [::Uploading::Event::PhotoUploaded])
    cqrs.subscribe(FileProcessing::Worker::RecognizeDimensions, [::Uploading::Event::PhotoUploaded])

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::Command::SetFilename.new(photo_id: event.data.fetch(:photo_id), filename: event.data.fetch(:filename)))
      end,
      [Uploading::Event::PhotoUploaded]
    )

    cqrs.subscribe(
      lambda do |event|
        cqrs.run(Tagging::Command::RequestAutoTagging.new(photo_id: event.data.fetch(:photo_id)))
      end,
      [Reviewing::Event::PhotoApproved]
    )

    cqrs.subscribe(
      ImageProcessing.new(event_store: event_store, command_bus: command_bus),
      [
        Uploading::Event::PhotoUploaded,
        FileProcessing::Event::DimensionsRecognized,
        FileProcessing::Event::AverageColorExtracted
      ]
    )

    cqrs.subscribe(
      PhotoPublishing.new(event_store: event_store, command_bus: command_bus),
      [
        FileProcessing::Event::ProcessingFinished,
        CopyrightCheck::Event::Found,
        CopyrightCheck::Event::NotFound,
        Reviewing::Event::PhotoRejected,
        Reviewing::Event::PhotoPreApproved,
        Reviewing::Event::PhotoApproved,
        Publishing::Event::PhotoPublished,
        Publishing::Event::PhotoUnpublished
      ]
    )
  end
end
