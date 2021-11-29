module Reviewing
  class PhotoApproved < ::Event
    attribute :photo_id, Types::UUID
  end
end
