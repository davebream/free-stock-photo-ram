module Tagging
  class PhotoService
    include CommandHandler

    def assign_filename(command)
      with_photo(command.aggregate_id) do |photo|
        photo.assign_filename(command.filename)
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

      Success()

    rescue Tagging::Photo::TagAlreadyAdded
      Failure('One of the tags has been already added')
    end

    def remove_tag(command)
      with_photo(command.aggregate_id) do |photo|
        photo.remove_tag(command.tag_id)
      end
    end

    def with_photo(photo_id, &block)
      with_aggregate(Photo, photo_id, &block)
    end
  end
end
