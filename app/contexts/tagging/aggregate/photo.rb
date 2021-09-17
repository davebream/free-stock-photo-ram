module Tagging
  module Aggregate
    class Photo
      include AggregateRoot

      NoPathSet = Class.new(StandardError)

      Tag = Struct.new(:uid, :name, :source, :provider)

      def initialize(uid)
        @uid = uid
        @path = nil
        @tags = []
      end

      def set_path(path)
        apply Event::PathSet.new(data: { uid: uid, path: path })
      end

      def request_auto_tagging
        return if already_auto_tagged?

        raise NoPathSet unless path?

        apply Event::AutoTaggingRequested.new(data: { uid: uid, path: path })
      end

      def add_auto_tags(tags, provider)
        apply Event::AutoTagsAdded.new(data: { uid: uid, tags: tags, provider: provider })
      end

      def add_tags(tags)
        apply Event::TagsAdded.new(data: { uid: uid, tags: tags })
      end

      def remove_tag
        apply Event::TagRemoved.new(data: { uid: uid })
      end

      private

      attr_reader :uid, :path, :tags

      on Event::PathSet do |event|
        @path = event.data.fetch(:path)
      end

      on Event::TagRemoved do |event|
        @tags.reject! { |tag| tag.uid == event.data.fetch(:uid) }
      end

      on Event::AutoTaggingRequested do |_event|
      end

      on Event::AutoTagsAdded do |event|
        @auto_tagged = true
        @tags << event.data.fetch(:tags).map do |tag|
          Tag.new(uid: tag[:uid], name: tag[:name], source: 'external', provider: event.data.fetch(:provider))
        end
      end

      on Event::TagsAdded do |event|
        @tags << event.data.fetch(:tags).map do |tag|
          Tag.new(uid: tag[:uid], name: tag[:name], source: 'admin')
        end
      end

      def already_auto_tagged?
        @auto_tagged
      end

      def path?
        @path.present?
      end

      attr_reader :state
    end
  end
end
