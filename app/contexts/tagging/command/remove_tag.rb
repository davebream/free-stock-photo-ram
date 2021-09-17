module Tagging
  module Command
    class RemoveTag < ::Command
      attribute :uid, Types::UUID

      alias :aggregate_id :uid
    end
  end
end
