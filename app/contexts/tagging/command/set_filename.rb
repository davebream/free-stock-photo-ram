module Tagging
  module Command
    class SetFilename < ::Command
      attribute :photo_id, Types::UUID
      attribute :filename, Types::Strict::String

      alias :aggregate_id :photo_id
    end
  end
end
