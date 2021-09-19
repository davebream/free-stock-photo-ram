module Tagging
  class PhotoService
    include CommandHandler

    def set_filename(command)
      with_photo(command.aggregate_id) do |photo|
        photo.set_filename(command.filename)
      end
    end

    def request_auto_tagging(command)
      with_photo(command.aggregate_id, &:request_auto_tagging)
    end

    def add_auto_tags(command)
      with_photo(command.aggregate_id) do |photo|
        photo.add_auto_tags(command.tags, command.provider)
      end
    end

    def add_tags(command)
      with_photo(command.aggregate_id) do |photo|
        photo.add_tags(command.tags)
      end
    end

    def remove_tag(command)
      with_photo(command.aggregate_id) do |photo|
        photo.remove_tag(command.tag_id)
      end
    end

    def with_photo(photo_id)
      with_aggregate(Photo, photo_id) do |photo|
        yield photo
      end
    end
  end
end
