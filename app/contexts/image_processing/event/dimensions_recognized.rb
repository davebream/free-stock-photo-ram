module ImageProcessing
  module Event
    class DimensionsRecognized < ::Event
      attribute :uid, Types::UUID
      attribute :width, Types::Strict::Integer
      attribute :height, Types::Strict::Integer
    end
  end
end
