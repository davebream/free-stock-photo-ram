module Tagging
  module Event
    class TagRemoved < ::Event
      attribute :tag_id, Types::UUID
    end
  end
end
