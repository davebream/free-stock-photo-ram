module Tagging
  module Command
    class AddAutoTags < ::Command
      attribute :photo_id, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
      attribute :provider, Types::Strict::String

      alias aggregate_id photo_id
    end

    class AddTags < ::Command
      attribute :photo_id, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)

      alias aggregate_id photo_id
    end

    class AssignFilename < ::Command
      attribute :photo_id, Types::UUID
      attribute :filename, Types::Strict::String

      alias aggregate_id photo_id
    end

    class RemoveTag < ::Command
      attribute :photo_id, Types::UUID
      attribute :tag_id, Types::UUID

      alias aggregate_id photo_id
    end

    class RequestAutoTagging < ::Command
      attribute :photo_id, Types::UUID

      alias aggregate_id photo_id
    end
  end
end
