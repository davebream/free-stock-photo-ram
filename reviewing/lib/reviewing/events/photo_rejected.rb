module Reviewing
  class PhotoRejected < ::Event
    attribute :photo_id, Types::UUID
  end
end
