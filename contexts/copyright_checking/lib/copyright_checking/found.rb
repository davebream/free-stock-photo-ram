module CopyrightChecking
  class Found < ::Event
    attribute :photo_id, Types::UUID
  end
end
