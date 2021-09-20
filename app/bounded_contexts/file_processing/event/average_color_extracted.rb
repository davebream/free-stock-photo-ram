module FileProcessing
  module Event
    class AverageColorExtracted < ::Event
      attribute :photo_id, Types::UUID
      attribute :rgb, Types::Array.of(Types::Strict::Integer)
    end
  end
end
