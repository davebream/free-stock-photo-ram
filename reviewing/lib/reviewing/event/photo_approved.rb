module Reviewing
  module Event
    class PhotoApproved < ::Event
      attribute :photo_id, Types::UUID
    end
  end
end
