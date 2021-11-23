module Reviewing
  class ApprovePhoto < ::Command
    attribute :photo_id, Types::UUID
  end
end
