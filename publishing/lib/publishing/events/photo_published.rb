module Publishing
  class PhotoPublished < ::Event
    attribute :photo_id, Types::UUID
  end
end
