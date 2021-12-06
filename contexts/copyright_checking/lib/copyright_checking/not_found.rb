module CopyrightChecking
  class NotFound < ::Event
    attribute :photo_id, Types::UUID
  end
end
