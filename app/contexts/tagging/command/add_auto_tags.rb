module Tagging
  module Command
    class AddAutoTags < ::Command
      attribute :uid, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)
      attribute :provider, Types::Strict::String

      alias :aggregate_id :uid
    end
  end
end
