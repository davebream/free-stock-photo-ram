module UI
  module Reviewing
    class OnImageUploaded
      def call(event)
        photo = UI::Reviewing::Photo.find_or_initialize_by(id: event.data.fetch(:uid))
        photo.filename = event.data.fetch(:filename)
        photo.status = 'uploaded'
        photo.uploaded_at = event.timestamp
        photo.save!
      end
    end
  end
end
