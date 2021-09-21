module Reviewing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(Reviewing::RegisterPhoto, Reviewing::PhotoService.new)
      @cqrs.register(Reviewing::PreApprovePhoto, Reviewing::PhotoService.new)
      @cqrs.register(Reviewing::ApprovePhoto, Reviewing::PhotoService.new)
      @cqrs.register(Reviewing::RejectPhoto, Reviewing::PhotoService.new)
    end
  end
end
