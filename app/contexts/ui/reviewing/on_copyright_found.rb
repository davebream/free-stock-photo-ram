module UI
  module Reviewing
    class OnCopyrightFound
      def call(event)
        UI::Reviewing::Photo.set_copyright(event.data.fetch(:image_id), 'found')
      end
    end
  end
end
