module Publishing
  class PhotoUnpublished < ::Event
    attribute :photo_id, Types::UUID
  end
end
