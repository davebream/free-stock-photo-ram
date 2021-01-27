module Uploading
  module Event
    class PhotoUploaded < ::Event
      SCHEMA = {
        uid: String,
        user_uid: String,
        tmp_path: String,
        filesize: [:optional, Integer]
      }.freeze
    end
  end
end
