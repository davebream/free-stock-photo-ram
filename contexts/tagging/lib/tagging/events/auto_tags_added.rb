module Tagging
  class AutoTagsAdded < ::Event
    attribute :photo_id, Types::UUID
    attribute :tags, Types::Array.of(Types::Hash)
    attribute :provider, Types::Strict::String
  end
end
