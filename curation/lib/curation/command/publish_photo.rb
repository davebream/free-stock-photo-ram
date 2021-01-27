module Curation
  module Command
    class PublishPhoto < ::Command
      attribute :uid, Types::UUID
      attribute :publish_at, Types::Time

      alias aggregate_id uid
    end
  end
end
