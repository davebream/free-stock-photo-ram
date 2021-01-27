module MediaProcessing
  module ProcessManager
    class PhotoProcessing
      class State
        attr_reader :uid, :tmp_path

        def initialize
          @uid = nil
          @tmp_path = nil
          @width = nil
          @height = nil
          @average_color = nil

          @version = -1
          @event_ids_to_link = []
        end

        # DECISION MAKING
        def processed?
          uid.present? && dimensions_set? && average_color_set?
        end

        def dimensions_set?
          width && height
        end

        def average_color_set?
          average_color.present?
        end

        # APPLY STATE
        def apply(event)
          case event
          when Uploading::Event::PhotoUploaded
            @uid = event.data[:uid]
            @tmp_path = event.data[:tmp_path]
          when MediaProcessing::Event::PhotoAverageColorExtracted
            @average_color = event.data[:rgb]
          when MediaProcessing::Event::PhotoDimensionsRecognized
            @width = event.data[:width]
            @height = event.data[:height]
          end

          @event_ids_to_link << event.event_id
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

        private

        attr_reader :width, :height, :average_color
      end
      private_constant :State

      def initialize(event_store:, command_bus:)
        @event_store = event_store
        @command_bus = command_bus
      end

      def call(event)
        stream_name = "#{self.class.name}$#{event.data[:uid]}"

        state = State.new
        state.load(stream_name, event_store: event_store)
        state.apply(event)
        state.store(stream_name, event_store: event_store)

        if state.processed?
          command_bus.call(Curation::Command::RegisterPhoto.new(uid: state.uid))
        end
      end

      private

      attr_reader :command_bus, :event_store
    end
  end
end
