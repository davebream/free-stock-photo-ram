module FileProcessing
  class ProcessingFinished < ::Event
    attribute :image_id, Types::UUID
    attribute :average_color, Types::Array.of(Types::Strict::Integer)
    attribute :width, Types::Strict::Integer
    attribute :height, Types::Strict::Integer
  end
end
