module Tagging
  module Command
    class AddAutoTags < ::Command
      attribute :photo_id, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
      attribute :provider, Types::Strict::String

      alias :aggregate_id :photo_id
    end
  end
end
