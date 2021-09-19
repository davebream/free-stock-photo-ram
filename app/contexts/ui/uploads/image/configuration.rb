module UI
  module Uploads
    class Image
      class Configuration
        def initialize(cqrs)
          @cqrs = cqrs
        end

        def call
          subscribe(-> (event) { acknowledge_image_uploaded(event) }, [::Uploading::Event::ImageUploaded])
          subscribe(-> (event) { finish_processing(event) }, [::ImgeProcessing::Event::ProcessingFinished])
        end

        private

        def acknowledge_image_uploaded(event)
          with_image(event) do |image|
            image.filename = event.data.fetch(:filename)
            image.path = event.data.fetch(:path)
            image.uploaded_at = event.timestamp
          end
        end

        def finish_processing(event)
          with_image(event) do |image|
            image.width = event.data.fetch(:width)
            image.height = event.data.fetch(:height)
            image.average_color = event.data.fetch(:average_color)
          end
        end

        def with_image(event)
          UI::Uploads::Image.find_or_initialize_by(id: event.data.fetch(:image_id)).tap do |image|
            yield image
            image.save!
          end
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
          @cqrs.link_event_to_stream(event, "UI::Uploads::Image$#{event.data.fetch(:image_id)}")
        end
      end
    end
  end
end
