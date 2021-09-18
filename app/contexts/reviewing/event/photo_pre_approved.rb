module Reviewing
  module Event
    class PhotoPreApproved < ::Event
      attribute :photo_id, Types::UUID
    end
  end
end
