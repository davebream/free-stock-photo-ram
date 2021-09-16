# frozen_string_literal: true

class Configuration
  def call(event_store, command_bus)
    cqrs = CQRS.new(event_store, command_bus)

    UI::Configuration.new(cqrs).call
    ImageProcessing::Configuration.new(cqrs).call
    Reviewing::Configuration.new(cqrs).call
    Publishing::Configuration.new(cqrs).call

    cqrs.subscribe(CopyrightCheck::Worker::Search, [::Uploading::Event::ImageUploaded])
    cqrs.subscribe(ImageProcessing::Worker::ExtractAverageColor, [::Uploading::Event::ImageUploaded])
    cqrs.subscribe(ImageProcessing::Worker::RecognizeDimensions, [::Uploading::Event::ImageUploaded])

    cqrs.subscribe(
      ImageProcessing::Process.new(event_store: event_store, command_bus: command_bus),
      [
        Uploading::Event::ImageUploaded,
        ImageProcessing::Event::DimensionsRecognized,
        ImageProcessing::Event::AverageColorExtracted
      ]
    )

    cqrs.subscribe(
      Publishing::PhotoPublishingProcess.new(event_store: event_store, command_bus: command_bus),
      [
        ImageProcessing::Event::ProcessingFinished,
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
