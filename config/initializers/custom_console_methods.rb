module CustomConsoleMethods
  def cqrs
    Rails.configuration.cqrs
  end

  def last_events(limit = 10)
    event_store.read.backward.limit(limit).to_a
  end

  def last_event
    last_events(1).first
  end

  delegate :event_store, :command_bus, to: :cqrs
end

require 'rails/console/helpers'
Rails::ConsoleMethods.prepend(CustomConsoleMethods)
