module UI
  module Reviewing
    class OnPhotoUnpublished
      def call(event)
        UI::Reviewing::Photo.set_attribute(event.data.fetch(:uid), :publish_at, nil)
      end
    end
  end
end
