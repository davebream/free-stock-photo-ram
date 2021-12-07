module PhotoTags
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
      @subscriptions = {}
    end

    def call
      subscribe(-> (event) { assign_filename(event) }, [::Tagging::FilenameAssigned])
      subscribe(-> (event) { add_auto_tags(event) }, [::Tagging::AutoTagsAdded])
      subscribe(-> (event) { add_tags(event) }, [::Tagging::TagsAdded])
      subscribe(-> (event) { remove_tag(event) }, [::Tagging::TagRemoved])
      cqrs.register_rebuilder('photo_tags_read_model', public_method(:rebuild))
    end

    def rebuild
      PhotoTags::Tag.delete_all
      PhotoTags::Photo.delete_all

      cqrs.event_store.read.of_type(subscriptions.keys).each do |event|
        subscriptions[event.class.to_s].each do |handler|
          handler.call(event)
        end
      end
    end

    private

    attr_reader :cqrs, :subscriptions

    def subscribe(handler, events)
      cqrs.subscribe(-> (event) { handler.call(event) }, events)

      events.each do |event_klass|
        @subscriptions[event_klass.to_s] ||= []
        @subscriptions[event_klass.to_s] << handler
      end
    end

    def assign_filename(event)
      with_photo(event) do |photo|
        photo.filename = event.data.fetch(:filename)
      end
    end

    def add_auto_tags(event)
      with_photo(event) do |photo|
        photo.last_tagging_at = event.timestamp
      end

      create_tags(
        event.data.fetch(:tags).map do |tag|
          {
            photo_id: event.data.fetch(:photo_id),
            id: tag.fetch(:id),
            name: tag.fetch(:name),
            source: 'external',
            provider: event.data.fetch(:provider),
            added_at: event.timestamp
          }
        end
      )
    end

    def add_tags(event)
      with_photo(event) do |photo|
        photo.last_tagging_at = event.timestamp
      end

      create_tags(
        event.data.fetch(:tags).map do |tag|
          {
            photo_id: event.data.fetch(:photo_id),
            id: tag.fetch(:id),
            name: tag.fetch(:name),
            source: 'admin',
            added_at: event.timestamp
          }
        end
      )
    end

    def remove_tag(event)
      PhotoTags::Tag.delete(event.data.fetch(:tag_id))
    end

    def with_photo(event)
      PhotoTags::Photo.find_or_initialize_by(id: event.data.fetch(:photo_id)).tap do |photo|
        yield photo
        photo.save!
      end
    end

    def create_tags(tags)
      PhotoTags::Tag.upsert_all(tags) if tags.any?
    end
  end
end
