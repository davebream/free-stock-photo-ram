class PhotoPublishing
  def initialize(cqrs)
    @cqrs = cqrs
  end

  def call(event)
    state = build_state(event)

    publish(state) if state.publish?
    return unless state.unpublish?
    unpublish(state)
  end

  private

  def publish(state)
    cqrs.run(Publishing::PublishPhoto.new(photo_id: state.photo_id))
  end

  def unpublish(state)
    cqrs.run(Publishing::UnpublishPhoto.new(photo_id: state.photo_id))
  end

  def build_state(event)
    photo_id = stream_id(event)
    stream_name = "PhotoPublishing$#{photo_id}"
    past_events = cqrs.all_events_from_stream(stream_name)
    last_stored = past_events.size - 1
    cqrs.link_event_to_stream(event, stream_name, last_stored)

    ProcessState.new(photo_id).tap do |state|
      past_events.each { |ev| state.call(ev) }
      state.call(event)
    end
  rescue RubyEventStore::WrongExpectedEventVersion
    retry
  end

  def stream_id(event)
    case event
      when FileProcessing::ProcessingFinished, CopyrightChecking::Found, CopyrightChecking::NotFound
        event.data.fetch(:image_id)
      else
        event.data.fetch(:photo_id)
    end
  end

  attr_reader :cqrs

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
        when FileProcessing::ProcessingFinished
          @processed = true
        when CopyrightChecking::Found
          @copyright_state = :found
        when CopyrightChecking::NotFound
          @copyright_state = :not_found
        when Reviewing::PhotoRejected
          @reviewing_state = :rejected
        when Reviewing::PhotoPreApproved
          @reviewing_state = :pre_approved
        when Reviewing::PhotoApproved
          @reviewing_state = :approved
        when Publishing::PhotoPublished
          @published = true
        when Publishing::PhotoUnpublished
          @published = false
      end
    end
  end
end
