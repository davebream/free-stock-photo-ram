module Tagging
  module Command
    class SetPath < ::Command
      attribute :photo_id, Types::UUID
      attribute :path, Types::Strict::String

      alias :aggregate_id :photo_id
    end
  end
end
