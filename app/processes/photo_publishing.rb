class PhotoPublishing
  def initialize(event_store:, command_bus:)
    @event_store = event_store
    @command_bus = command_bus
  end

  def call(event)
    state = build_state(event)

    if state.publish?
      publish(state)
      return
    end

    if state.unpublish?
      unpublish(state)
    end
  end

  private

  def publish(state)
    command_bus.call(Publishing::Command::PublishPhoto.new(id: state.photo_id))
  end

  def unpublish(state)
    command_bus.call(Publishing::Command::UnpublishPhoto.new(id: state.photo_id))
  end

  attr_reader :event_store, :command_bus

  def build_state(event)
    stream_name = "PhotoPublishing$#{event.data.fetch(:photo_id)}"
    past_events = event_store.read.stream(stream_name).to_a
    last_stored = past_events.size - 1
    event_store.link(event.event_id, stream_name: stream_name, expected_version: last_stored)

    ProcessState.new.tap do |state|
      past_events.each{ |ev| state.call(ev) }
      state.call(event)
    end
  rescue RubyEventStore::WrongExpectedEventVersion
    retry
  end

  class ProcessState
    attr_reader :photo_id

    def initialize
      @photo_id = nil
      @reviewing_status = nil
      @copyright_status = nil
      @published = false
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

    def call(event)
      case event
      when FileProcessing::Event::ProcessingFinished
        @photo_id = event.data.fetch(:photo_id)
      when CopyrightCheck::Event::Found
        @copyright_status = :found
      when CopyrightCheck::Event::NotFound
        @copyright_status = :not_found
      when Reviewing::Event::PhotoRejected
        @reviewing_status = :rejected
      when Reviewing::Event::PhotoPreApproved
        @reviewing_status = :pre_approved
      when Reviewing::Event::PhotoApproved
        @reviewing_status = :approved
      when Publishing::Event::PhotoPublished
        @published = true
      when Publishing::Event::PhotoUnpublished
        @published = false
      end
    end
  end
end
