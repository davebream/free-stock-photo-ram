module Reviewing
  module Command
    class RejectPhoto < ::Command
      attribute :uid, Types::UUID

      alias :aggregate_id :uid
    end
  end
end
