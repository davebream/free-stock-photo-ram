module Reviewing
  class PhotoPreApproved < ::Event
    attribute :photo_id, Types::UUID
  end
end
