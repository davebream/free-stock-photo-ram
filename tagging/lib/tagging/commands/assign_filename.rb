module Tagging
  class AssignFilename < ::Command
    attribute :photo_id, Types::UUID
    attribute :filename, Types::Strict::String

    alias aggregate_id photo_id
  end
end
