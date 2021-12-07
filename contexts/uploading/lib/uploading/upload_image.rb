module Uploading
  class UploadImage
    def initialize(uploading_service)
      @uploading_service = uploading_service
    end

    def call(photo_id)
      filename = uploading_service.call

      Rails.configuration.cqrs.publish(
        Uploading::ImageUploaded.new(data: { photo_id: photo_id, filename: filename })
      )
    end

    private

    attr_reader :uploading_service
  end
end
