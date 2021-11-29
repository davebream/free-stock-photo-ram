module Reviewing
  class PreApprovePhoto < ::Command
    attribute :photo_id, Types::UUID
  end
end
