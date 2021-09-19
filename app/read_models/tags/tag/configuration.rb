module Tags
  class Tag
    class Configuration
      def initialize(cqrs)
        @cqrs = cqrs
      end

      def call
        @cqrs.subscribe(-> (event) { remove_tag(event) }, [::Tagging::Event::TagRemoved])
      end

      private

      def remove_tag(event)
        Tag.delete(event.data.fetch(:tag_id))
      end
    end
  end
end
