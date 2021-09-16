module ImageProcessing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(ImageProcessing::Command::FinishProcessing, ImageProcessing::CommandHandler::OnFinishProcessing.new)
    end
  end
end
