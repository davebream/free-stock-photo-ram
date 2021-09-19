module FileProcessing
  module Command
    class FinishProcessing < ::Command
      attribute :photo_id, Types::UUID
      attribute :average_color, Types::Array.of(Types::Strict::Integer)
      attribute :width, Types::Strict::Integer
      attribute :height, Types::Strict::Integer
    end
  end
end
