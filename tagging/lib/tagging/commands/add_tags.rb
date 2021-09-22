module Tagging
  class AddTags < ::Command
    attribute :photo_id, Types::UUID
    attribute :tags, Types::Array.of(Types::Hash)

    alias aggregate_id photo_id
  end
end
