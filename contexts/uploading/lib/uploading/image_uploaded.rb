module Uploading
  class ImageUploaded < ::Event
    attribute :image_id, Types::UUID
    attribute :filename, Types::Strict::String
  end
end
