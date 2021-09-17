module Tagging
  module CommandHandler
    class OnSetPath
      include ::CommandHandler

      def call(command)
        ActiveRecord::Base.transaction do
          with_aggregate(Tagging::Aggregate::Photo, command.aggregate_id) do |photo|
            photo.set_path(command.path)
          end
        end
      end
    end
  end
end
