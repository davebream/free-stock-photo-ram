module Publishing
  class Photo
    include AggregateRoot

    def initialize(id)
      @id = id
      @published = false
    end

    def publish
      return if published?

      apply PhotoPublished.new(data: { photo_id: @id })
    end

    def unpublish
      return if unpublished?

      apply PhotoUnpublished.new(data: { photo_id: @id })
    end

    private

    on PhotoPublished do |_event|
      @published = true
    end

    on PhotoUnpublished do |_event|
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
