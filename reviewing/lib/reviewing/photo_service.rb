module Reviewing
  class PhotoService
    include CommandHandler

    def pre_approve_photo(command)
      with_photo(command.aggregate_id, &:pre_approve)
    end

    def reject_photo(command)
      with_photo(command.aggregate_id, &:reject)
    end

    def approve_photo(command)
      with_photo(command.aggregate_id, &:approve)
    end

    def with_photo(photo_id, &block)
      with_aggregate(Photo, photo_id, &block)
    end
  end
end
