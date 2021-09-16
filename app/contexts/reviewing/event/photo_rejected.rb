module Reviewing
  module Event
    class PhotoRejected < ::Event
      attribute :uid, Types::UUID
    end
  end
end
