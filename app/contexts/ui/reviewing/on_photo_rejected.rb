module UI
  module Reviewing
    class OnPhotoRejected
      def call(event)
        UI::Reviewing::Photo.set_status(event.data.fetch(:uid), 'rejected')
      end
    end
  end
end
