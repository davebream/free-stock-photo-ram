module Tagging
  module Command
    class AddTags < ::Command
      attribute :uid, Types::UUID
      attribute :tags, Types::Array.of(Types::Hash)

      alias :aggregate_id :uid
    end
  end
end
