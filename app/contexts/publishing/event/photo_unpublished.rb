module Publishing
  module Event
    class PhotoUnpublished < ::Event
      attribute :photo_id, Types::UUID
    end
  end
end
