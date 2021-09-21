module Tags
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.subscribe(-> (event) { assign_filename(event) }, [::Tagging::Event::FilenameAssigned])
      @cqrs.subscribe(-> (event) { add_auto_tags(event) }, [::Tagging::Event::AutoTagsAdded])
      @cqrs.subscribe(-> (event) { add_tags(event) }, [::Tagging::Event::TagsAdded])
      @cqrs.subscribe(-> (event) { remove_tag(event) }, [::Tagging::Event::TagRemoved])
    end

    private

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
      Tags::Tag.delete(event.data.fetch(:tag_id))
    end

    def with_photo(event)
      Tags::Photo.find_or_initialize_by(id: event.data.fetch(:photo_id)).tap do |photo|
        yield photo
        photo.save!
      end
    end

    def create_tags(tags)
      Tags::Tag.upsert_all(tags) if tags.any?
    end
  end
end
