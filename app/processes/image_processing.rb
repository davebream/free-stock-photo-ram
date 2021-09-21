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
        photo_id: state.photo_id,
        average_color: state.average_color,
        width: state.width,
        height: state.height
      )
    )
  end

  def build_state(event)
    photo_id = event.data.fetch(:photo_id)
    stream_name = "ImageProcessing$#{photo_id}"
    past_events = event_store.read.stream(stream_name).to_a
    last_stored = past_events.size - 1
    event_store.link(event.event_id, stream_name: stream_name, expected_version: last_stored)

    ProcessState.new(photo_id).tap do |state|
      past_events.each { |ev| state.call(ev) }
      state.call(event)
    end
  rescue RubyEventStore::WrongExpectedEventVersion
    retry
  end

  class ProcessState
    attr_reader :photo_id, :average_color, :width, :height

    def initialize(photo_id)
      @photo_id = photo_id
      @average_color = nil
      @width = nil
      @height = nil
    end

    def processing_finished?
      average_color_extracted? && dimensions_recognized?
    end

    def average_color_extracted?
      @average_color.present?
    end

    def dimensions_recognized?
      @height.present? && @width.present?
    end

    def call(event)
      case event
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
