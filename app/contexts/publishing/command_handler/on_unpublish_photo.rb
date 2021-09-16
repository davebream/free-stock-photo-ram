module Publishing
  module CommandHandler
    class OnUnpublishPhoto
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Publishing::Aggregate::Photo, command.aggregate_id, &:unpublish)
        end
      end
    end
  end
end
