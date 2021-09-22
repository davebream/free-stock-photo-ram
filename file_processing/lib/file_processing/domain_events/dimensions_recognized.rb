module FileProcessing
  class DimensionsRecognized < ::Event
    attribute :image_id, Types::UUID
    attribute :width, Types::Strict::Integer
    attribute :height, Types::Strict::Integer
  end
end
