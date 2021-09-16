module Reviewing
  module Aggregate
    class Photo
      include AggregateRoot

      NotYetPreApproved = Class.new(StandardError)
      HasBeenRejected = Class.new(StandardError)

      def initialize(uid)
        @uid = uid
        @state = :new
      end

      def reject
        return if rejected?
        apply Event::PhotoRejected.new(data: { uid: @uid })
      end

      def pre_approve
        return if pre_approved? || approved?
        apply Event::PhotoPreApproved.new(data: { uid: @uid })
      end

      def approve
        return if approved?
        raise HasBeenRejected if rejected?
        raise NotYetPreApproved unless pre_approved?

        apply Event::PhotoApproved.new(data: { uid: @uid })
      end

      private

      on Event::PhotoRejected do |_event|
        @state = :rejected
      end

      on Event::PhotoPreApproved do |_event|
        @state = :pre_approved
      end

      on Event::PhotoApproved do |_event|
        @state = :approved
      end

      def pre_approved?
        @state == :pre_approved
      end

      def approved?
        @state == :approved
      end

      def rejected?
        @state == :rejected
      end

      attr_reader :state
    end
  end
end
