module Curation
  class PhotoPublished < Event
    SCHEMA = {
      uid: String,
      publish_at: Time
    }.freeze

    def self.strict(data:)
      ClassyHash.validate(data, SCHEMA)
      new(data: data)
    end
  end
end
