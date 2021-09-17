module Tagging
  module Event
    class TagRemoved < ::Event
      attribute :uid, Types::UUID
    end
  end
end
