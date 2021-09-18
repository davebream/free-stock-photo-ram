module CopyrightCheck
  module Event
    class NotFound < ::Event
      attribute :image_id, Types::UUID
    end
  end
end
