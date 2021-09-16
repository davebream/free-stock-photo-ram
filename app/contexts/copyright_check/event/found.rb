module CopyrightCheck
  module Event
    class Found < ::Event
      attribute :uid, Types::UUID
    end
  end
end
