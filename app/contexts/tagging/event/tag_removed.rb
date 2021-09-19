module Tagging
  module Event
    class TagRemoved < ::Event
      attribute :photo_id, Types::UUID
      attribute :tag_id, Types::UUID
    end
  end
end
