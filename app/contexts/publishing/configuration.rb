module Publishing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(Publishing::Command::PublishPhoto, Publishing::PhotoService.new)
      @cqrs.register(Publishing::Command::UnpublishPhoto, Publishing::PhotoService.new)
    end
  end
end
