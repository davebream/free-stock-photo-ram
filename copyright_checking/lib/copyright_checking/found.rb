module CopyrightChecking
  class Found < ::Event
    attribute :image_id, Types::UUID
  end
end
