module Curation
  class OnRegisterPhoto
    include CommandHandler

    def call(command)
      ActiveRecord::Base.transaction do
        with_aggregate(Curation::Photo, command.aggregate_id, &:register)
      end
    end
  end
end
