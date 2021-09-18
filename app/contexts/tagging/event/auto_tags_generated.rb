module Tagging
  module Event
    class AutoTagsGenerated < ::Event
      attribute :photo_id, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
      attribute :provider, Types::Strict::String
    end
  end
end
