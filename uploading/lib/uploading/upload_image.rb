module Uploading
  class UploadImage
    def initialize(uploading_service)
      @uploading_service = uploading_service
    end

    def call(image_id)
      uploading_service.call do |filename|
        event_store.publish(
          Uploading::ImageUploaded.new(data: { image_id: image_id, filename: filename })
        )
      end
    end

    private

    attr_reader :uploading_service

    def event_store
      Rails.configuration.event_store
    end
  end
end
