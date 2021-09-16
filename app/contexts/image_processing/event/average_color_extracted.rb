module ImageProcessing
  module Event
    class AverageColorExtracted < ::Event
      attribute :uid, Types::UUID
      attribute :rgb, Types::Array.of(Types::Strict::Integer)
    end
  end
end
