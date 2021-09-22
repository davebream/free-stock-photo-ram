module CopyrightChecking
  class NotFound < ::Event
    attribute :image_id, Types::UUID
  end
end
