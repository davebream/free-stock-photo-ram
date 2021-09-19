module Tagging
  class Photo
    include AggregateRoot

    MissingFilename = Class.new(StandardError)

    Tag = Struct.new(:id, :name, :source, :provider)

    def initialize(id)
      @id = id
      @filename = nil
      @tags = []
    end

    def set_filename(filename)
      apply Event::FilenameSet.new(data: { photo_id: id, filename: filename })
    end

    def request_auto_tagging
      return if already_auto_tagged?

      raise MissingFilename unless filename?

      apply Event::AutoTaggingRequested.new(data: { photo_id: id, filename: filename })
    end

    def add_auto_tags(tags, provider)
      apply Event::AutoTagsAdded.new(data: { photo_id: id, tags: tags, provider: provider })
    end

    def add_tags(tags)
      apply Event::TagsAdded.new(data: { photo_id: id, tags: tags })
    end

    def remove_tag(tag_id)
      apply Event::TagRemoved.new(data: { photo_id: id, tag_id: tag_id })
    end

    private

    attr_reader :id, :filename, :tags

    on Event::FilenameSet do |event|
      @filename = event.data.fetch(:filename)
    end

    on Event::TagRemoved do |event|
      @tags.reject! { |tag| tag.id == event.data.fetch(:tag_id) }
    end

    on Event::AutoTaggingRequested do |_event|
    end

    on Event::AutoTagsAdded do |event|
      @auto_tagged = true

      event.data.fetch(:tags).each do |tag|
        @tags << Tag.new(id: tag[:id], name: tag[:name], source: 'external', provider: event.data.fetch(:provider))
      end
    end

    on Event::TagsAdded do |event|
      event.data.fetch(:tags).each do |tag|
        @tags << Tag.new(id: tag[:id], name: tag[:name], source: 'admin')
      end
    end

    def already_auto_tagged?
      @auto_tagged
    end

    def filename?
      @filename.present?
    end

    attr_reader :state
  end
end
