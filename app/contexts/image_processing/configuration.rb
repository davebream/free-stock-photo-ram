module ImageProcessing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(ImageProcessing::Command::FinishProcessing, ImageProcessing::ImageService.new)
    end
  end
end
