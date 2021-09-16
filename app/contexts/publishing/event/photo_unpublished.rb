module Publishing
  module Event
    class PhotoUnpublished < ::Event
      attribute :uid, Types::UUID
    end
  end
end
