module Publishing
  class Photo
    include AggregateRoot

    def initialize(id)
      @id = id
      @published = false
    end

    def publish
      return if published?

      apply Event::PhotoPublished.new(data: { photo_id: @id })
    end

    def unpublish
      return if unpublished?

      apply Event::PhotoUnpublished.new(data: { photo_id: @id })
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
