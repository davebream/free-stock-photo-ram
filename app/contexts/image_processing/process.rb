module ImageProcessing
  class Process
    class State
      attr_reader :uid, :average_color, :width, :height

      def initialize
        @uid = nil
        @average_color = nil
        @width = nil
        @height = nil

        @version           = -1
        @event_ids_to_link = []
      end

      def processing_finished?
        uid.present? && average_color_extracted? && dimensions_recognized?
      end

      def average_color_extracted?
        @average_color.present?
      end

      def dimensions_recognized?
        @height.present? && @width.present?
      end

      def set_average_color(rgb)
        @average_color = rgb
      end

      def set_width(width)
        @width = width
      end

      def set_height(height)
        @height = height
      end

      def set_uid(uid)
        @uid = uid
      end

      def apply(*events)
        events.each do |event|
          case event
          when Uploading::Event::ImageUploaded
            set_uid(event.data.fetch(:uid))
          when ImageProcessing::Event::DimensionsRecognized
            set_width(event.data.fetch(:width))
            set_height(event.data.fetch(:height))
          when ImageProcessing::Event::AverageColorExtracted
            set_average_color(event.data.fetch(:rgb))
          end

          @event_ids_to_link << event.event_id
        end
      end

      def load(stream_name, event_store:)
        event_store.read.stream(stream_name).forward.each do |event|
          apply(event)
          @version += 1
        end

        @event_ids_to_link = []
      end

      def store(stream_name, event_store:)
        event_store.link(
          @event_ids_to_link,
          stream_name: stream_name,
          expected_version: @version
        )

        @version += @event_ids_to_link.size
        @event_ids_to_link = []
      rescue RubyEventStore::WrongExpectedEventVersion
        retry
      end
    end
    private_constant :State

    def initialize(event_store:, command_bus:)
      @event_store = event_store
      @command_bus = command_bus
    end

    def call(event)
      stream_name = "ImageProcessing::Process$#{event.data[:uid]}"

      state = State.new
      state.load(stream_name, event_store: event_store)
      state.apply(event)
      state.store(stream_name, event_store: event_store)

      if state.processing_finished?
        command_bus.call(
          ImageProcessing::Command::FinishProcessing.new(
            uid: state.uid,
            average_color: state.average_color,
            width: state.width,
            height: state.height
          )
        )
      end
    end

    private

    attr_reader :event_store, :command_bus
  end
end
