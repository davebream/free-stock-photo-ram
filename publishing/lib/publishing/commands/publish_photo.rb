module Publishing
  class PublishPhoto < ::Command
    attribute :photo_id, Types::UUID
  end
end
