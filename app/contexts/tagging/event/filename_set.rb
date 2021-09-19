module Tagging
  module Event
    class FilenameSet < ::Event
      attribute :photo_id, Types::UUID
      attribute :filename, Types::Strict::String
    end
  end
end
