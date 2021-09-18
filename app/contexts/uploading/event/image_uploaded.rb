module Uploading
  module Event
    class ImageUploaded < ::Event
      attribute :image_id, Types::UUID
      attribute :filename, Types::Strict::String
      attribute :path, Types::Strict::String
    end
  end
end
