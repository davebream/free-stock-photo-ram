module CopyrightChecking
  module Event
    class Found < ::Event
      attribute :image_id, Types::UUID
    end

    class NotFound < ::Event
      attribute :image_id, Types::UUID
    end
  end
end
