module Tagging
  module CommandHandler
    class OnRemoveTag
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Tagging::Aggregate::Photo, command.aggregate_id, &:remove_tag)
        end
      end
    end
  end
end
