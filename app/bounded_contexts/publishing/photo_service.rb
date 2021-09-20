module Publishing
  class PhotoService
    include CommandHandler

    def publish_photo(command)
      with_photo(command.aggregate_id, &:publish)
    end

    def unpublish_photo(command)
      with_photo(command.aggregate_id, &:unpublish)
    end

    def with_photo(photo_id)
      with_aggregate(Photo, photo_id) do |photo|
        yield photo
      end
    end
  end
end
