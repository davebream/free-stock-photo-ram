module Reviewing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(Reviewing::Command::RegisterPhoto, Reviewing::PhotoService.new)
      @cqrs.register(Reviewing::Command::PreApprovePhoto, Reviewing::PhotoService.new)
      @cqrs.register(Reviewing::Command::ApprovePhoto, Reviewing::PhotoService.new)
      @cqrs.register(Reviewing::Command::RejectPhoto, Reviewing::PhotoService.new)
    end
  end
end
