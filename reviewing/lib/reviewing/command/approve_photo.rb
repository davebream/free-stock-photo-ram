module Reviewing
  module Command
    class ApprovePhoto < ::Command
      attribute :photo_id, Types::UUID

      alias aggregate_id photo_id
    end
  end
end
