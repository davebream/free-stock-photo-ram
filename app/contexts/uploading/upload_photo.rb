module Uploading
  class UploadPhoto
    class << self
      def call(photo_id, file)
        filename = photo_id + File.extname(file)
        url_path = File.join('images', filename)
        path = File.join(Rails.public_path, url_path)
        IO.binwrite(path, file.read)

        publish_photo_uploaded_event(photo_id, filename, path, url_path)
      end

      private

      def publish_photo_uploaded_event(photo_id, filename, path, url_path)
        Rails.configuration.event_store.publish(
          Uploading::Event::PhotoUploaded.new(data: {
            photo_id: photo_id,
            filename: filename,
            path: path,
            url_path: url_path
          })
        )
      end
    end
  end
end
