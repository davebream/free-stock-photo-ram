module Reviewing
  module Command
    class PreApprovePhoto < ::Command
      attribute :uid, Types::UUID

      alias :aggregate_id :uid
    end
  end
end
