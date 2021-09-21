module CopyrightChecking
  module Event
    class Found < ::Event
      attribute :photo_id, Types::UUID
    end

    class NotFound < ::Event
      attribute :photo_id, Types::UUID
    end
  end
end
