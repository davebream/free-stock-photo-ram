module Curation
  module CommandHandler
    class OnMarkCopyrightAsNotFound
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Curation::Aggregate::Photo, command.aggregate_id, &:mark_copyright_as_not_found)
        end
      end
    end
  end
end
