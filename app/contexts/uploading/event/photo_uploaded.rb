module Uploading
  module Event
    class PhotoUploaded < ::Event
      attribute :photo_id, Types::UUID
      attribute :filename, Types::Strict::String
      attribute :path, Types::Strict::String
    end
  end
end
