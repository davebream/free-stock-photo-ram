module Reviewing
  module CommandHandler
    class OnRejectPhoto
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Reviewing::Aggregate::Photo, command.aggregate_id, &:reject)
        end
      end
    end
  end
end
