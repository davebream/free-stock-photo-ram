module Publishing
  module Aggregate
    class Photo
      include AggregateRoot

      def initialize(uid)
        @uid = uid
        @published = false
      end

      def publish
        return if published?

        apply Event::PhotoPublished.new(data: { uid: @uid })
      end

      def unpublish
        return if unpublished?

        apply Event::PhotoUnpublished.new(data: { uid: @uid })
      end

      private

      on Event::PhotoPublished do |_event|
        @published = true
      end

      on Event::PhotoUnpublished do |_event|
        @published = false
      end

      def published?
        @published == true
      end

      def unpublished?
        @published == false
      end

      attr_reader :state
    end
  end
end
