module Curation
  module Command
    class MarkCopyrightAsNotFound < ::Command
      attribute :uid, Types::UUID

      alias aggregate_id uid
    end
  end
end
