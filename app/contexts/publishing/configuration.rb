module Publishing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(Publishing::Command::PublishPhoto, Publishing::CommandHandler::OnPublishPhoto.new)
      @cqrs.register(Publishing::Command::UnpublishPhoto, Publishing::CommandHandler::OnUnpublishPhoto.new)
    end
  end
end
