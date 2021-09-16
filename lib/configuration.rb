# frozen_string_literal: true

class Configuration
  def call(event_store, command_bus)
    cqrs = CQRS.new(event_store, command_bus)

    UI::Configuration.new(cqrs).call
    ImageProcessing::Configuration.new(cqrs).call
    Reviewing::Configuration.new(cqrs).call
    Publishing::Configuration.new(cqrs).call

    cqrs.subscribe(
      ->(event) { ::CopyrightCheck::Worker::Search.perform_async(event.data.fetch(:uid)) },
      [::Uploading::Event::ImageUploaded]
    )

    cqrs.subscribe(
      lambda do |event|
        ImageProcessing::Worker::ExtractAverageColor.perform_async(event.data.fetch(:uid), event.data.fetch(:path))
        ImageProcessing::Worker::RecognizeDimensions.perform_async(event.data.fetch(:uid), event.data.fetch(:path))
      end,
      [::Uploading::Event::ImageUploaded]
    )

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
