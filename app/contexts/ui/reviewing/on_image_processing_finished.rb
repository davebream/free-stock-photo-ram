module UI
  module Reviewing
    class OnImageProcessingFinished
      def call(event)
        UI::Reviewing::Photo.set_status(event.data.fetch(:image_id), 'processed')
      end
    end
  end
end
