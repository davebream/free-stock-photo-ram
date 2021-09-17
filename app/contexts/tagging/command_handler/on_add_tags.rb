module Tagging
  module CommandHandler
    class OnAddTags
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Tagging::Aggregate::Photo, command.aggregate_id) do |photo|
            photo.add_tags(command.tags)
          end
        end
      end
    end
  end
end
