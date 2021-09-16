module UI
  module Reviewing
    class OnCopyrightNotFound
      def call(event)
        UI::Reviewing::Photo.set_copyright(event.data.fetch(:uid), 'ok')
      end
    end
  end
end
