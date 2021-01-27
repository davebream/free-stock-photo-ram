module MediaProcessing
  module Event
    class PhotoAverageColorExtracted < ::Event
      SCHEMA = {
        uid: String,
        rgb: [[Integer]]
      }.freeze
    end
  end
end
