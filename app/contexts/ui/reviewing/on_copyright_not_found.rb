module UI
  module Reviewing
    class OnCopyrightNotFound
      def call(event)
        UI::Reviewing::Photo.set_copyright(event.data.fetch(:image_id), 'ok')
      end
    end
  end
end
