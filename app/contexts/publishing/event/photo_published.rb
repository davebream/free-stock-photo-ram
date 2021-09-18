module Publishing
  module Event
    class PhotoPublished < ::Event
      attribute :photo_id, Types::UUID
    end
  end
end
