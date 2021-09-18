module CopyrightCheck
  module Event
    class Found < ::Event
      attribute :image_id, Types::UUID
    end
  end
end
