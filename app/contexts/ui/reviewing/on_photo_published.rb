module UI
  module Reviewing
    class OnPhotoPublished
      def call(event)
        UI::Reviewing::Photo.set_attribute(event.data.fetch(:uid), :publish_at, event.timestamp)
      end
    end
  end
end
