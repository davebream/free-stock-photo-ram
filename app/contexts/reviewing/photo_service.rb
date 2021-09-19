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

    def with_photo(photo_id)
      with_aggregate(Photo, photo_id) do |photo|
        yield photo
      end
    end
  end
end
