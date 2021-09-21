module Tagging
  module Event
    class AutoTaggingRequested < ::Event
      attribute :photo_id, Types::UUID
      attribute :filename, Types::Strict::String
    end

    class AutoTagsAdded < ::Event
      attribute :photo_id, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
      attribute :provider, Types::Strict::String
    end

    class AutoTagsGenerated < ::Event
      attribute :photo_id, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
      attribute :provider, Types::Strict::String
    end

    class FilenameAssigned < ::Event
      attribute :photo_id, Types::UUID
      attribute :filename, Types::Strict::String
    end

    class TagRemoved < ::Event
      attribute :photo_id, Types::UUID
      attribute :tag_id, Types::UUID
    end

    class TagsAdded < ::Event
      attribute :photo_id, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
    end
  end
end
