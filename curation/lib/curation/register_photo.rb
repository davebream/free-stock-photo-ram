module Curation
  class RegisterPhoto < Command
    attribute :uid, Types::UUID

    alias aggregate_id uid
  end
end
