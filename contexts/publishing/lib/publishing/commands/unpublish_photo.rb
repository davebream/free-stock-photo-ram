module Publishing
  class UnpublishPhoto < ::Command
    attribute :photo_id, Types::UUID
  end
end
