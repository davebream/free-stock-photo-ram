module Tagging
  module Event
    class AutoTaggingRequested < ::Event
      attribute :photo_id, Types::UUID
      attribute :path, Types::Strict::String
    end
  end
end
