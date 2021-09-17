module Tagging
  module CommandHandler
    class OnRequestAutoTagging
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Tagging::Aggregate::Photo, command.aggregate_id, &:request_auto_tagging)
        end
      end
    end
  end
end
