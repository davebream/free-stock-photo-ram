module MediaProcessing
  module Event
    class PhotoDimensionsRecognized < ::Event
      SCHEMA = {
        uid: String,
        width: [Integer],
        height: [Integer],
      }.freeze
    end
  end
end
