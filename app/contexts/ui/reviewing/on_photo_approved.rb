module UI
  module Reviewing
    class OnPhotoApproved
      def call(event)
        UI::Reviewing::Photo.set_status(event.data.fetch(:uid), 'approved')
      end
    end
  end
end
