module Tagging
  class Photo
    include AggregateRoot

    TagAlreadyAdded = Class.new(StandardError)
    MissingFilename = Class.new(StandardError)

    Tag = Struct.new(:id, :name, :source, :provider)

    def initialize(id)
      @id = id
      @filename = nil
      @tags = []
    end

    def assign_filename(filename)
      apply FilenameAssigned.new(data: { photo_id: id, filename: filename })
    end

    def request_auto_tagging
      return if already_auto_tagged?
      raise MissingFilename unless filename?

      apply AutoTaggingRequested.new(data: { photo_id: id, filename: filename })
    end

    def add_auto_tags(tags, provider)
      apply AutoTagsAdded.new(data: { photo_id: id, tags: tags, provider: provider })
    end

    def add_tags(tags)
      raise TagAlreadyAdded if tags_already_added?(tags)

      apply TagsAdded.new(data: { photo_id: id, tags: tags })
    end

    def remove_tag(tag_id)
      apply TagRemoved.new(data: { photo_id: id, tag_id: tag_id })
    end

    private

    on FilenameAssigned do |event|
      @filename = event.data.fetch(:filename)
    end

    on TagRemoved do |event|
      @tags.reject! { |tag| tag.id == event.data.fetch(:tag_id) }
    end

    on AutoTaggingRequested do |event|
    end

    on AutoTagsAdded do |event|
      @auto_tagged = true

      event.data.fetch(:tags).each do |tag|
        @tags << Tag.new(tag[:id], tag[:name], 'external', event.data.fetch(:provider))
      end
    end

    on TagsAdded do |event|
      event.data.fetch(:tags).each do |tag|
        @tags << Tag.new(tag[:id], tag[:name], 'admin')
      end
    end

    def tags_already_added?(new_tags)
      tags.map(&:name).intersection(new_tags.pluck(:name)).any?
    end

    def already_auto_tagged?
      @auto_tagged
    end

    def filename?
      @filename.present?
    end

    attr_reader :state, :id, :filename, :tags
  end
end
