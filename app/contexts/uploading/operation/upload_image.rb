module Uploading
  module Operation
    class UploadImage
      class << self
        def call(uid, file)
          filename = uid + File.extname(file)
          url_path = File.join('images', filename)
          path = File.join(Rails.public_path, url_path)
          IO.binwrite(path, file.read)

          publish_image_uploaded_event(uid, filename, path, url_path)
        end

        private

        def publish_image_uploaded_event(uid, filename, path, url_path)
          event_store.publish(
            Uploading::Event::ImageUploaded.new(data: { uid: uid, filename: filename, path: path, url_path: url_path })
          )
        end

        def event_store
          Rails.configuration.event_store
        end
      end
    end
  end
end