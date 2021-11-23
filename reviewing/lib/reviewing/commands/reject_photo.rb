module Reviewing
  class RejectPhoto < ::Command
    attribute :photo_id, Types::UUID
  end
end
