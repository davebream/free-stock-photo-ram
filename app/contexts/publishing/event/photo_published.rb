module Publishing
  module Event
    class PhotoPublished < ::Event
      attribute :uid, Types::UUID
    end
  end
end
