module UI
  module Reviewing
    class OnPhotoPreApproved
      def call(event)
        UI::Reviewing::Photo.set_status(event.data.fetch(:uid), 'pre_approved')
      end
    end
  end
end
