module Curation
  module CommandHandler
    class OnRegisterPhoto
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Curation::Aggregate::Photo, command.aggregate_id, &:register)
        end
      end
    end
  end
end
