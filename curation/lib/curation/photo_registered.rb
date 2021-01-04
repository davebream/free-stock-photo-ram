module Curation
  class PhotoRegistered < Event
    SCHEMA = {
      uid: String
    }.freeze

    def self.strict(data:)
      ClassyHash.validate(data, SCHEMA)
      new(data: data)
    end
  end
end
