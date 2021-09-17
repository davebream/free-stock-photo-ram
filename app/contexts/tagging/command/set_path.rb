module Tagging
  module Command
    class SetPath < ::Command
      attribute :uid, Types::UUID
      attribute :path, Types::Strict::String

      alias :aggregate_id :uid
    end
  end
end
