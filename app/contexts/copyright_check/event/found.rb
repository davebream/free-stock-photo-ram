module CopyrightCheck
  module Event
    class Found < ::Event
      attribute :photo_id, Types::UUID
      attribute :image_id, Types::UUID
    end
  end
end
