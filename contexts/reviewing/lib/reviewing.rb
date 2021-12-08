module Reviewing
  class Configuration
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call
      photo_service = Reviewing::PhotoService.new(cqrs)

      cqrs.register(Reviewing::PreApprovePhoto, photo_service.public_method(:pre_approve))
      cqrs.register(Reviewing::ApprovePhoto, photo_service.public_method(:approve))
      cqrs.register(Reviewing::RejectPhoto, photo_service.public_method(:reject))
    end

    private

    attr_reader :cqrs
  end
end
