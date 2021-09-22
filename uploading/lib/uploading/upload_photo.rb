module Uploading
  class UploadPhoto
    def initialize(uploading_service)
      @uploading_service = uploading_service
    end

    def call(image_id)
      uploading_service.call do |correlation_id, filename, url_path, path|
        event_store.publish(
          Uploading::Event::PhotoUploaded.new(
            data: {
              image_id: image_id,
              filename: filename,
              path: path,
              url_path: url_path
            },
            metadata: {
              correlation_id: correlation_id
            }
          )
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
