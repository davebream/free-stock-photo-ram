module Reviewing
  module Event
    class PhotoPreApproved < ::Event
      attribute :uid, Types::UUID
    end
  end
end
