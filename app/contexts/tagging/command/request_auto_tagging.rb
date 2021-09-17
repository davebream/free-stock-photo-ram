module Tagging
  module Command
    class RequestAutoTagging < ::Command
      attribute :uid, Types::UUID

      alias :aggregate_id :uid
    end
  end
end
