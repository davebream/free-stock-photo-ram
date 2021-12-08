module FileProcessing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      photo_service = FileProcessing::PhotoService.new(cqrs)

      cqrs.register(FileProcessing::FinishProcessing, photo_service.public_method(:finish_processing))
    end

    private

    attr_reader :cqrs
  end
end
