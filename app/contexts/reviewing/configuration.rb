module Reviewing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      @cqrs.register(Reviewing::Command::PreApprovePhoto, Reviewing::CommandHandler::OnPreApprovePhoto.new)
      @cqrs.register(Reviewing::Command::ApprovePhoto, Reviewing::CommandHandler::OnApprovePhoto.new)
      @cqrs.register(Reviewing::Command::RejectPhoto, Reviewing::CommandHandler::OnRejectPhoto.new)
    end
  end
end
