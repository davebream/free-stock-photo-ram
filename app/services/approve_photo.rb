class ApprovePhoto
  include Dry::Monads[:result]

  def call(photo_id)
    with_transaction do
      command = Reviewing::ApprovePhoto.new(photo_id: photo_id, correlation_id: photo_id)
      command_bus.call(command)
    end

    Success()

  rescue StandardError => e
    failure(e)
  end

  private

  def command_bus
    Rails.configuration.command_bus
  end

  def with_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  def failure(exp)
    case exp
      when Reviewing::Photo::NotYetPreApproved then Failure(message: 'Photo not yet pre approved')
      when Reviewing::Photo::HasBeenRejected then Failure(message: 'Approving rejected photos forbidden')
      else Failure(error: exp.class.name.demodulize.underscore, message: exp.message)
    end
  end
end
