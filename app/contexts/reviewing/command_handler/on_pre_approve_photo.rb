module Reviewing
  module CommandHandler
    class OnPreApprovePhoto
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Reviewing::Aggregate::Photo, command.aggregate_id, &:pre_approve)
        end
      end
    end
  end
end
