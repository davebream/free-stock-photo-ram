module Tagging
  class Photo
    include AggregateRoot

    NoPathSet = Class.new(StandardError)

    Tag = Struct.new(:id, :name, :source, :provider)

    def initialize(id)
      @id = id
      @path = nil
      @tags = []
    end

    def set_path(path)
      apply Event::PathSet.new(data: { photo_id: id, path: path })
    end

    def request_auto_tagging
      return if already_auto_tagged?

      raise NoPathSet unless path?

      apply Event::AutoTaggingRequested.new(data: { photo_id: id, path: path })
    end

    def add_auto_tags(tags, provider)
      apply Event::AutoTagsAdded.new(data: { photo_id: id, tags: tags, provider: provider })
    end

    def add_tags(tags)
      apply Event::TagsAdded.new(data: { photo_id: id, tags: tags })
    end

    def remove_tag(tag_id)
      apply Event::TagRemoved.new(data: { tag_id: tag_id })
    end

    private

    attr_reader :id, :path, :tags

    on Event::PathSet do |event|
      @path = event.data.fetch(:path)
    end

    on Event::TagRemoved do |event|
      @tags.reject! { |tag| tag.id == event.data.fetch(:tag_id) }
    end

    on Event::AutoTaggingRequested do |_event|
    end

    on Event::AutoTagsAdded do |event|
      @auto_tagged = true
      @tags << event.data.fetch(:tags).map do |tag|
        Tag.new(id: tag[:id], name: tag[:name], source: 'external', provider: event.data.fetch(:provider))
      end
    end

    on Event::TagsAdded do |event|
      @tags << event.data.fetch(:tags).map do |tag|
        Tag.new(id: tag[:id], name: tag[:name], source: 'admin')
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
