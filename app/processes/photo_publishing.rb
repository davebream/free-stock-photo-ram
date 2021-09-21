class PhotoPublishing
  def initialize(event_store, command_bus)
    @event_store = event_store
    @command_bus = command_bus
  end

  def call(event)
    state = build_state(event)

    publish(state) if state.publish?
    return unless state.unpublish?
    unpublish(state)
  end

  private

  def publish(state)
    command_bus.call(Publishing::Command::PublishPhoto.new(photo_id: state.photo_id))
  end

  def unpublish(state)
    command_bus.call(Publishing::Command::UnpublishPhoto.new(photo_id: state.photo_id))
  end

  attr_reader :event_store, :command_bus

  def build_state(event)
    photo_id = event.data.fetch(:photo_id)
    stream_name = "PhotoPublishing$#{photo_id}"
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
    attr_reader :photo_id

    def initialize(photo_id)
      @photo_id = photo_id
      @processed = false
      @reviewing_state = nil
      @copyright_state = nil
      @published = false
    end

    def processed?
      @processed
    end

    def published?
      @published
    end

    def unpublished?
      !published?
    end

    def approved?
      @reviewing_state == :approved
    end

    def not_approved?
      !approved?
    end

    def copyright_not_found?
      @copyright_state == :not_found
    end

    def copyright_found?
      @copyright_state == :found
    end

    def publish?
      processed? && unpublished? && approved? && copyright_not_found?
    end

    def unpublish?
      published? && (not_approved? || copyright_found?)
    end

    def call(event)
      case event
        when FileProcessing::Event::ProcessingFinished
          @processed = true
        when CopyrightChecking::Event::Found
          @copyright_state = :found
        when CopyrightChecking::Event::NotFound
          @copyright_state = :not_found
        when Reviewing::PhotoRejected
          @reviewing_state = :rejected
        when Reviewing::PhotoPreApproved
          @reviewing_state = :pre_approved
        when Reviewing::PhotoApproved
          @reviewing_state = :approved
        when Publishing::Event::PhotoPublished
          @published = true
        when Publishing::Event::PhotoUnpublished
          @published = false
      end
    end
  end
end
