module MediaProcessing
  module EventHandler
    class OnPhotoUploaded
      def call(event)
        uid = event.data.fetch(:uid)
        tmp_path = event.data.fetch(:tmp_path)

        extract_average_color(uid, tmp_path)
        recognize_dimensions(uid, tmp_path)
      end

      private

      def extract_average_color(uid, tmp_path)
        MediaProcessing::Service::ExtractPhotoAverageColor.new.call(uid, tmp_path)
      end

      def recognize_dimensions(uid, tmp_path)
        MediaProcessing::Service::RecognizePhotoDimensions.new.call(uid, tmp_path)
      end
    end
  end
end
