module UI
  module Tagging
    class OnTagRemoved
      def call(event)
        Tag.delete(event.data.fetch(:tag_id))
      end
    end
  end
end
