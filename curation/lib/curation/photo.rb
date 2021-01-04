module Curation
  class Photo
    include AggregateRoot

    NotRegistered = Class.new(StandardError)
    AlreadyRegistered = Class.new(StandardError)
    HasBeenRejected = Class.new(StandardError)
    CopyrightNotConfirmed = Class.new(StandardError)
    CopyrightInfringed = Class.new(StandardError)

    def initialize(uid)
      @uid = uid
      @state = :new
      @copyright = :initial
    end

    def register
      raise AlreadyRegistered if @state == :registered

      apply PhotoRegistered.strict(data: { uid: @uid })
    end

    def mark_copyright_as_not_found
      apply PhotoCopyrightNotFound.strict(data: { uid: @uid })
    end

    def mark_copyright_as_found
      apply PhotoCopyrightFound.strict(data: { uid: @uid })
    end

    def reject
      apply PhotoRejected.strict(data: { uid: @uid })
    end

    def publish(publish_at = Time.current)
      raise NotRegistered if @state == :new
      raise HasBeenRejected if @state == :rejected
      raise CopyrightNotConfirmed if @copyright == :initial
      raise CopyrightInfringed if @copyright == :found

      apply PhotoPublished.strict(data: { uid: @uid, publish_at: publish_at })
    end

    on PhotoRegistered do |_event|
      @state = :registered
    end

    on PhotoRejected do |_event|
      @state = :rejected
    end

    on PhotoPublished do |_event|
      @state = :published
    end

    on PhotoCopyrightNotFound do |_event|
      @copyright = :not_found
    end

    on PhotoCopyrightFound do |_event|
      @copyright = :found
    end

    private

    attr_reader :state
  end
end
