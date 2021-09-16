module Publishing
  module Command
    class UnpublishPhoto < ::Command
      attribute :uid, Types::UUID

      alias :aggregate_id :uid
    end
  end
end
