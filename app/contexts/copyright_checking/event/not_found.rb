module CopyrightChecking
  module Event
    class NotFound < ::Event
      attribute :photo_id, Types::UUID
    end
  end
end
