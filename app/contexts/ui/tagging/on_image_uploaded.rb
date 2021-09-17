module UI
  module Tagging
    class OnImageUploaded
      def call(event)
        photo = UI::Tagging::Photo.find_or_initialize_by(id: event.data.fetch(:uid))
        photo.filename = event.data.fetch(:filename)
        photo.save!
      end
    end
  end
end
