module FileProcessing
  module Event
    class AverageColorExtracted < ::Event
      attribute :photo_id, Types::UUID
      attribute :rgb, Types::Array.of(Types::Strict::Integer)
    end

    class DimensionsRecognized < ::Event
      attribute :photo_id, Types::UUID
      attribute :width, Types::Strict::Integer
      attribute :height, Types::Strict::Integer
    end

    class ProcessingFinished < ::Event
      attribute :photo_id, Types::UUID
      attribute :average_color, Types::Array.of(Types::Strict::Integer)
      attribute :width, Types::Strict::Integer
      attribute :height, Types::Strict::Integer
    end
  end
end
