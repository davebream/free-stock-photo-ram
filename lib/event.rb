# frozen_string_literal: true

class Event < RailsEventStore::Event
  def self.strict(data:)
    ClassyHash.validate(data, self::SCHEMA)
    new(data: data)
  end
end
