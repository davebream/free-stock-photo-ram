module Tagging
  module Event
    class AutoTagsAdded < ::Event
      attribute :uid, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
      attribute :provider, Types::Strict::String
    end
  end
end
