module Publishing
  class PhotoService
    include CommandHandler

    def publish_photo(command)
      with_photo(command.photo_id, &:publish)
    end

    def unpublish_photo(command)
      with_photo(command.photo_id, &:unpublish)
    end

    def with_photo(photo_id, &block)
      with_aggregate(Photo, photo_id, &block)
    end
  end
end
