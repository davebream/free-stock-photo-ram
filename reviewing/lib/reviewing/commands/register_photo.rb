module Reviewing
  class RegisterPhoto < ::Command
    attribute :photo_id, Types::UUID

    alias aggregate_id photo_id
  end
end