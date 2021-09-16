module Reviewing
  module CommandHandler
    class OnApprovePhoto
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Reviewing::Aggregate::Photo, command.aggregate_id, &:approve)
        end
      end
    end
  end
end
