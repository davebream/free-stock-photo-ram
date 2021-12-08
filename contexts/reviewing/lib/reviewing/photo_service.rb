module Reviewing
  class PhotoService
    include Dry::Monads[:result]

    def initialize(cqrs)
      @repository = AggregateRootRepository.new(cqrs.event_store)
    end

    def pre_approve(command)
      with_photo(command.photo_id, &:pre_approve)
    end

    def reject(command)
      with_photo(command.photo_id, &:reject)
    end

    def approve(command)
      with_photo(command.photo_id, &:approve)

      Success()

    rescue Reviewing::Photo::NotYetPreApproved
      Failure('Photo not yet pre approved')
    rescue Reviewing::Photo::HasBeenRejected
      Failure('Approving rejected photos forbidden')
    end

    private

    attr_reader :repository

    def with_photo(photo_id, &block)
      repository.with_aggregate(Photo, photo_id, &block)
    end
  end
end
