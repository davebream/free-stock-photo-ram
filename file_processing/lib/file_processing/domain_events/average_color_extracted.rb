module FileProcessing
  class AverageColorExtracted < ::Event
    attribute :image_id, Types::UUID
    attribute :rgb, Types::Array.of(Types::Strict::Integer)
  end
end
