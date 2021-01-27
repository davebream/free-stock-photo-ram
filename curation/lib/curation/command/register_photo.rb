module Curation
  module Command
    class RegisterPhoto < ::Command
      attribute :uid, Types::UUID

      alias aggregate_id uid
    end
  end
end
