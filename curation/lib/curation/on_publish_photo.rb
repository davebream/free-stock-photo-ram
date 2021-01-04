module Curation
  class OnPublishPhoto
    include CommandHandler

    def call(command)
      ActiveRecord::Base.transaction do
        with_aggregate(Curation::Photo, command.aggregate_id, &:publish)
      end
    end
  end
end
