module Tagging
  module Event
    class PathSet < ::Event
      attribute :uid, Types::UUID
      attribute :path, Types::Strict::String
    end
  end
end
