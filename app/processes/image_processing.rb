class ImageProcessing
  def initialize(cqrs)
    @cqrs = cqrs
  end

  def call(event)
    state = build_state(event)
    finish_processing(state) if state.processing_finished?
  end

  private

  def finish_processing(state)
    cqrs.run(
      FileProcessing::FinishProcessing.new(
        image_id: state.image_id,
        average_color: state.average_color,
        width: state.width,
        height: state.height
      )
    )
  end

  def build_state(event)
    image_id = event.data.fetch(:image_id)
    stream_name = "ImageProcessing$#{image_id}"
    past_events = cqrs.all_events_from_stream(stream_name)
    last_stored = past_events.size - 1
    cqrs.link_event_to_stream(event, stream_name, last_stored)

    ProcessState.new(image_id).tap do |state|
      past_events.each { |ev| state.call(ev) }
      state.call(event)
    end
  rescue RubyEventStore::WrongExpectedEventVersion
    retry
  end

  class ProcessState
    attr_reader :image_id, :average_color, :width, :height

    def initialize(image_id)
      @image_id = image_id
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
        when FileProcessing::DimensionsRecognized
          @width = event.data.fetch(:width)
          @height = event.data.fetch(:height)
        when FileProcessing::AverageColorExtracted
          @average_color = event.data.fetch(:rgb)
      end
    end
  end

  attr_reader :cqrs
end
