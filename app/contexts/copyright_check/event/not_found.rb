module CopyrightCheck
  module Event
    class NotFound < ::Event
      attribute :uid, Types::UUID
    end
  end
end
