module Publishing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      photo_service = Publishing::PhotoService.new(cqrs)

      cqrs.register(Publishing::PublishPhoto, photo_service.public_method(:publish))
      cqrs.register(Publishing::UnpublishPhoto, photo_service.public_method(:unpublish))
    end

    private

    attr_reader :cqrs
  end
end
