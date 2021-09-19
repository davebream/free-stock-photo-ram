module FileProcessing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(FileProcessing::Command::FinishProcessing, FileProcessing::PhotoService.new)
    end
  end
end
