module Reviewing
  module Command
    class ApprovePhoto < ::Command
      attribute :uid, Types::UUID

      alias :aggregate_id :uid
    end
  end
end
