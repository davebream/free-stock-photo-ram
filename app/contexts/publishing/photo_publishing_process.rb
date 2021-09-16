module Publishing
  class PhotoPublishingProcess
    class State
      attr_reader :uid

      def initialize
        @uid = nil
        @reviewing_status = nil
        @copyright_status = nil
        @published = false

        @version           = -1
        @event_ids_to_link = []
      end

      def published?
        @published
      end

      def unpublished?
        !published?
      end

      def approved?
        @reviewing_status == :approved
      end

      def unapproved?
        !approved?
      end

      def copyright_not_found?
        @copyright_status == :not_found
      end

      def copyright_found?
        @copyright_status == :found
      end

      def publish?
        unpublished? && approved? && copyright_not_found?
      end

      def unpublish?
        published? && (unapproved? || copyright_found?)
      end

      def set_reviewing_status(status)
        @reviewing_status = status.to_sym
      end

      def set_copyright_status(status)
        @copyright_status = status.to_sym
      end

      def set_published(bool)
        @published = bool
      end

      def set_uid(uid)
        @uid = uid
      end

      def apply(*events)
        events.each do |event|
          case event
          when ImageProcessing::Event::ProcessingFinished
            set_uid(event.data.fetch(:uid))
          when CopyrightCheck::Event::Found
            set_copyright_status(:found)
          when CopyrightCheck::Event::NotFound
            set_copyright_status(:not_found)
          when Reviewing::Event::PhotoRejected
            set_reviewing_status(:rejected)
          when Reviewing::Event::PhotoPreApproved
            set_reviewing_status(:pre_approved)
          when Reviewing::Event::PhotoApproved
            set_reviewing_status(:approved)
          when Publishing::Event::PhotoPublished
            set_published(true)
          when Publishing::Event::PhotoUnpublished
            set_published(false)
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
      stream_name = "Publishing::PhotoPublishingProcess$#{event.data[:uid]}"

      state = State.new
      state.load(stream_name, event_store: event_store)
      state.apply(event)
      state.store(stream_name, event_store: event_store)

      if state.publish?
        command_bus.call(Publishing::Command::PublishPhoto.new(uid: state.uid))
        return
      end

      if state.unpublish?
        command_bus.call(Publishing::Command::UnpublishPhoto.new(uid: state.uid))
      end
    end

    private

    attr_reader :event_store, :command_bus
  end
end
