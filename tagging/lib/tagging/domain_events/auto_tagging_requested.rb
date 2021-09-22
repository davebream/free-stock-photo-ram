module Tagging
  class AutoTaggingRequested < ::Event
    attribute :photo_id, Types::UUID
    attribute :filename, Types::Strict::String
  end
end
