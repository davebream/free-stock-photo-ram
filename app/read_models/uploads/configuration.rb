module Uploads
  class Configuration
    attr_reader :subscriptions

    def initialize(cqrs)
      @cqrs = cqrs
      @subscriptions = {}
    end

    def call
      subscribe(-> (event) { acknowledge_uploaded(event) }, [Uploading::Event::PhotoUploaded])
      subscribe(-> (event) { set_average_color(event) }, [FileProcessing::Event::AverageColorExtracted])
      subscribe(-> (event) { set_dimensions(event) }, [FileProcessing::Event::DimensionsRecognized])
    end

    def rebuild
      call

      Uploads::Photo.delete_all

      @cqrs.event_store.read.of_type(@subscriptions.keys).each do |event|
        @subscriptions[event.class.to_s].each do |handler|
          handler.call(event)
        end
      end
    end

    private

    def acknowledge_uploaded(event)
      with_photo(event) do |photo|
        photo.filename = event.data.fetch(:filename)
        photo.path = event.data.fetch(:path)
        photo.uploaded_at = event.timestamp
      end
    end

    def set_average_color(event)
      with_photo(event) do |photo|
        photo.average_color = event.data.fetch(:rgb)
      end
    end

    def set_dimensions(event)
      with_photo(event) do |photo|
        photo.width = event.data.fetch(:width)
        photo.height = event.data.fetch(:height)
      end
    end

    def with_photo(event)
      Uploads::Photo.find_or_initialize_by(id: event.data.fetch(:photo_id)).tap do |photo|
        yield photo
        photo.save!
      end
    end

    def subscribe(handler, events)
      @cqrs.subscribe(->(event) { handler.call(event) }, events)

      events.each do |event_klass|
        @subscriptions[event_klass.to_s] ||= []
        @subscriptions[event_klass.to_s] << handler
      end
    end
  end
end