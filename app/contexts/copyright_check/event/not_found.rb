module CopyrightCheck
  module Event
    class NotFound < ::Event
      attribute :photo_id, Types::UUID
      attribute :image_id, Types::UUID
    end
  end
end
