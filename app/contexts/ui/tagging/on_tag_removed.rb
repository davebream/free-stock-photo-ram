module UI
  module Tagging
    class OnTagRemoved
      def call(event)
        Tag.delete(event.data.fetch(:uid))
      end
    end
  end
end
