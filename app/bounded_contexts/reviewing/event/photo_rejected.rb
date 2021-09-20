module Reviewing
  module Event
    class PhotoRejected < ::Event
      attribute :photo_id, Types::UUID
    end
  end
end
