module Reviewing
  class RegisterPhoto < ::Command
    attribute :photo_id, Types::UUID
  end
end
