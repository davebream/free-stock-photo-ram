module Tagging
  module Event
    class AutoTaggingRequested < ::Event
      attribute :uid, Types::UUID
      attribute :path, Types::Strict::String
    end
  end
end
