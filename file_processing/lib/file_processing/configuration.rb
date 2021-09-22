module FileProcessing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(FileProcessing::FinishProcessing, FileProcessing::PhotoService.new)
    end
  end
end
