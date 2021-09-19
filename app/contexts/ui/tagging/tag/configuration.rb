module UI
  module Tagging
    class Tag
      class Configuration
        def initialize(cqrs)
          @cqrs = cqrs
        end

        def call
          subscribe(-> (event) { remove_tag(event) }, [::Tagging::Event::TagRemoved])
        end

        private

        def remove_tag(event)
          Tag.delete(event.data.fetch(:tag_id))
        end

        def subscribe(handler, events)
          @cqrs.subscribe(
            lambda do |event|
              link_to_stream(event)
              handler.call(event)
            end,
            events
          )
        end

        def link_to_stream(event)
          @cqrs.link_event_to_stream(event, "UI::Tagging::Tag$#{event.data.fetch(:tag_id)}")
        end
      end
    end
  end
end
