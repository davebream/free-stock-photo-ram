module Tagging
  module Event
    class TagsAdded < ::Event
      attribute :uid, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
    end
  end
end
