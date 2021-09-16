module Publishing
  module CommandHandler
    class OnPublishPhoto
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Publishing::Aggregate::Photo, command.aggregate_id, &:publish)
        end
      end
    end
  end
end
