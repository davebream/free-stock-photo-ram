module Tagging
  class RemoveTag < ::Command
    attribute :photo_id, Types::UUID
    attribute :tag_id, Types::UUID

    alias aggregate_id photo_id
  end
end
