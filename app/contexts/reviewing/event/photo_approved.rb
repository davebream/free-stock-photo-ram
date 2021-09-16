module Reviewing
  module Event
    class PhotoApproved < ::Event
      attribute :uid, Types::UUID
    end
  end
end
