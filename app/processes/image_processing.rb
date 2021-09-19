class ImageProcessing
  def initialize(event_store:, command_bus:)
    @event_store = event_store
    @command_bus = command_bus
  end

  def call(event)
    state = build_state(event)
    finish_processing(state) if state.processing_finished?
  end

  private

  def finish_processing(state)
    command_bus.call(
      FileProcessing::Command::FinishProcessing.new(
        image_id: state.image_id,
        photo_id: state.photo_id,
        average_color: state.average_color,
        width: state.width,
        height: state.height
      )
    )
  end

  def build_state(event)
    stream_name = "ImageProcessing$#{event.data.fetch(:image_id)}"
    past_events = store.read.stream(stream_name).to_a
    last_stored = past_events.size - 1
    store.link(event.event_id, stream_name: stream_name, expected_version: last_stored)

    ProcessState.new.tap do |state|
      past_events.each{ |ev| state.call(ev) }
      state.call(event)
    end
  rescue RubyEventStore::WrongExpectedEventVersion
    retry
  end

  class ProcessState
    attr_reader :image_id, :photo_id, :average_color, :width, :height

    def initialize
      @image_id = nil
      @photo_id = nil
      @average_color = nil
      @width = nil
      @height = nil
    end

    def processing_finished?
      image_id.present? && photo_id.present? && average_color_extracted? && dimensions_recognized?
    end

    def average_color_extracted?
      @average_color.present?
    end

    def dimensions_recognized?
      @height.present? && @width.present?
    end

    def call(event)
      case event
      when Uploading::Event::ImageUploaded
        @image_id = image_id
        @photo_id = event.data.fetch(:photo_id)
      when FileProcessing::Event::DimensionsRecognized
        @width = event.data.fetch(:width)
        @height = event.data.fetch(:height)
      when FileProcessing::Event::AverageColorExtracted
        @average_color = event.data.fetch(:rgb)
      end
    end
  end

  attr_reader :event_store, :command_bus
end
