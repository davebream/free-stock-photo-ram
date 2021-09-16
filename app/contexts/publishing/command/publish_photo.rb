module Publishing
  module Command
    class PublishPhoto < ::Command
      attribute :uid, Types::UUID

      alias :aggregate_id :uid
    end
  end
end
