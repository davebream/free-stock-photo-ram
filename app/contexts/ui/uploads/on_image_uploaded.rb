module UI
  module Uploads
    class OnImageUploaded
      def call(event)
        file = UI::Uploads::File.find_or_initialize_by(id: event.data.fetch(:uid))
        file.filename = event.data.fetch(:filename)
        file.path = event.data.fetch(:path)
        file.uploaded_at = event.timestamp
        file.save!
      end
    end
  end
end
