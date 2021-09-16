module ImageProcessing
  module Command
    class FinishProcessing < ::Command
      attribute :uid, Types::UUID
      attribute :average_color, Types::Array.of(Types::Strict::Integer)
      attribute :width, Types::Strict::Integer
      attribute :height, Types::Strict::Integer
    end
  end
end
