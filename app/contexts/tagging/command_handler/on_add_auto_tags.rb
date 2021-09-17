module Tagging
  module CommandHandler
    class OnAddAutoTags
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Tagging::Aggregate::Photo, command.aggregate_id) do |photo|
            photo.add_auto_tags(command.tags, command.provider)
          end
        end
      end
    end
  end
end
