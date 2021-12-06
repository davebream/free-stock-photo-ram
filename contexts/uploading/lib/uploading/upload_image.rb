module Uploading
  class UploadImage
    def initialize(uploading_service)
      @uploading_service = uploading_service
    end

    def call(photo_id)
      filename = uploading_service.call

      event_store.publish(
        Uploading::ImageUploaded.new(data: { photo_id: photo_id, filename: filename })
      )
    end

    private

    attr_reader :uploading_service

    def event_store
      Rails.configuration.event_store
    end
  end
end
