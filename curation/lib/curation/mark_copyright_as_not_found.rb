module Curation
  class MarkCopyrightAsNotFound < Command
    attribute :uid, Types::UUID

    alias aggregate_id uid
  end
end
