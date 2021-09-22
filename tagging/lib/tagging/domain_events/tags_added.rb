module Tagging
  class TagsAdded < ::Event
    attribute :photo_id, Types::UUID
    attribute :tags, Types::Array.of(Types::Hash)
  end
end
