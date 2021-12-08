module FileProcessing
  class PhotoService
    def initialize(cqrs)
      @cqrs = cqrs
      @repository = AggregateRootRepository.new(cqrs.event_store)
    end

    def finish_processing(command)
      cqrs.publish(
        FileProcessing::ProcessingFinished.new(
          data: {
            photo_id: command.photo_id,
            average_color: command.average_color,
            width: command.width,
            height: command.height
          }
        )
      )
    end

    private

    attr_reader :cqrs, :repository

    def with_photo(photo_id, &block)
      repository.with_aggregate(Photo, photo_id, &block)
    end
  end
end
