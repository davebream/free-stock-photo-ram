module Tags
  class Photo
    class Configuration
      def initialize(cqrs)
        @cqrs = cqrs
      end

      def call
        subscribe(-> (event) { set_filename(event) }, [::Tagging::Event::FilenameSet])
        subscribe(-> (event) { add_auto_tags(event) }, [::Tagging::Event::AutoTagsAdded])
        subscribe(-> (event) { add_tags(event) }, [::Tagging::Event::TagsAdded])
      end

      private

      def set_filename(event)
        with_photo(event) do |photo|
          photo.filename = event.data.fetch(:filename)
        end
      end

      def add_auto_tags(event)
        with_photo(event) do |photo|
          photo.last_tagging_at = event.timestamp
        end

        create_tags(event.data.fetch(:tags).map do |tag|
          {
            photo_id: event.data.fetch(:photo_id),
            id: tag.fetch(:id),
            name: tag.fetch(:name),
            source: 'external',
            provider: event.data.fetch(:provider),
            added_at: event.timestamp
          }
        end)
      end

      def add_tags(event)
        with_photo(event) do |photo|
          photo.last_tagging_at = event.timestamp
        end

        create_tags(event.data.fetch(:tags).map do |tag|
          {
            photo_id: event.data.fetch(:photo_id),
            id: tag.fetch(:id),
            name: tag.fetch(:name),
            source: 'admin',
            added_at: event.timestamp
          }
        end)
      end

      def with_photo(event)
        Tags::Photo.find_or_initialize_by(id: event.data.fetch(:photo_id)).tap do |photo|
          yield photo
          photo.save!
        end
      end

      def create_tags(tags)
        Tag.upsert_all(tags) if tags.any?
      end

      def subscribe(handler, events)
        @cqrs.subscribe(
          lambda do |event|
            link_to_stream(event)
            handler.call(event)
          end,
          events
        )
      end

      def link_to_stream(event)
        @cqrs.link_event_to_stream(event, "Tags::Photo$#{event.data.fetch(:photo_id)}")
      end
    end
  end
end
