module Curation
  module Aggregate
    class Photo
      include AggregateRoot

      NotRegistered = Class.new(StandardError)
      AlreadyRegistered = Class.new(StandardError)
      HasBeenRejected = Class.new(StandardError)
      CopyrightNotVerified = Class.new(StandardError)
      CopyrightInfringed = Class.new(StandardError)

      def initialize(uid)
        @uid = uid
        @state = :new
        @copyright = :initial
      end

      def register
        raise AlreadyRegistered if registered?

        apply Event::PhotoRegistered.strict(data: { uid: @uid })
      end

      def mark_copyright_as_not_found
        apply Event::PhotoCopyrightNotFound.strict(data: { uid: @uid })
      end

      def mark_copyright_as_found
        apply Event::PhotoCopyrightFound.strict(data: { uid: @uid })
      end

      def reject
        apply Event::PhotoRejected.strict(data: { uid: @uid })
      end

      def publish(publish_at = Time.current)
        raise NotRegistered if initial?
        raise HasBeenRejected if rejected?
        raise CopyrightNotVerified unless copyright_verified?
        raise CopyrightInfringed if copyright_found?

        apply Event::PhotoPublished.strict(data: { uid: @uid, publish_at: publish_at })
      end

      private

      on Event::PhotoRegistered do |_event|
        @state = :registered
      end

      on Event::PhotoRejected do |_event|
        @state = :rejected
      end

      on Event::PhotoPublished do |_event|
        @state = :published
      end

      on Event::PhotoCopyrightNotFound do |_event|
        @copyright = :not_found
      end

      on Event::PhotoCopyrightFound do |_event|
        @copyright = :found
      end

      def initial?
        @state == :new
      end

      def registered?
        @state == :registered
      end

      def rejected?
        @state == :rejected
      end

      def copyright_found?
        @copyright == :found
      end

      def copyright_verified?
        @copyright != :initial
      end

      attr_reader :state
    end
  end
end
