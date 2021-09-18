module UI
  module Reviewing
    class OnPhotoUnpublished
      def call(event)
        UI::Reviewing::Photo.set_attribute(event.data.fetch(:photo_id), :publish_at, nil)
      end
    end
  end
end
