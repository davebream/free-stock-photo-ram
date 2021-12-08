module Publishing
  class PhotoService
    def initialize(cqrs)
      @repository = AggregateRootRepository.new(cqrs.event_store)
    end

    def publish(command)
      with_photo(command.photo_id, &:publish)
    end

    def unpublish(command)
      with_photo(command.photo_id, &:unpublish)
    end

    private

    attr_reader :repository

    def with_photo(photo_id, &block)
      repository.with_aggregate(Photo, photo_id, &block)
    end
  end
end
