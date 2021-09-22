module Publishing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(Publishing::PublishPhoto, Publishing::PhotoService.new)
      @cqrs.register(Publishing::UnpublishPhoto, Publishing::PhotoService.new)
    end
  end
end
