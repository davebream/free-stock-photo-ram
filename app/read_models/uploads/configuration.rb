module Uploads
  class Configuration
    attr_reader :subscriptions

    def initialize(cqrs)
      @cqrs = cqrs
      @subscriptions = {}
    end

    def call
      subscribe(-> (event) { acknowledge_uploaded(event) }, [Uploading::ImageUploaded])
      subscribe(-> (event) { set_average_color(event) }, [FileProcessing::AverageColorExtracted])
      subscribe(-> (event) { set_dimensions(event) }, [FileProcessing::DimensionsRecognized])
    end

    def rebuild
      call

      Uploads::Image.delete_all

      @cqrs.event_store.read.of_type(@subscriptions.keys).each do |event|
        @subscriptions[event.class.to_s].each do |handler|
          handler.call(event)
        end
      end
    end

    private

    def acknowledge_uploaded(event)
      with_image(event) do |image|
        image.filename = event.data.fetch(:filename)
        image.uploaded_at = event.timestamp
      end
    end

    def set_average_color(event)
      with_image(event) do |image|
        image.average_color = event.data.fetch(:rgb)
      end
    end

    def set_dimensions(event)
      with_image(event) do |image|
        image.width = event.data.fetch(:width)
        image.height = event.data.fetch(:height)
      end
    end

    def with_image(event)
      Uploads::Image.find_or_initialize_by(id: event.data.fetch(:image_id)).tap do |image|
        yield image
        image.save!
      end
    end

    def subscribe(handler, events)
      @cqrs.subscribe(-> (event) { handler.call(event) }, events)

      events.each do |event_klass|
        @subscriptions[event_klass.to_s] ||= []
        @subscriptions[event_klass.to_s] << handler
      end
    end
  end
end
