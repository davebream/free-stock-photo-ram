module Publishing
  module Command
    class PublishPhoto < ::Command
      attribute :photo_id, Types::UUID

      alias :aggregate_id :photo_id
    end
  end
end
