class CQRS
  attr_reader :event_store

  def initialize(event_store, command_bus)
    @event_store = event_store
    @command_bus = command_bus
  end

  def subscribe(subscriber, events)
    @event_store.subscribe(subscriber, to: events)
  end

  def register(command, command_handler)
    @command_bus.register(command, command_handler)
  end

  def run(command)
    @command_bus.call(command)
  end

  def link_event_to_stream(event, stream)
    @event_store.link(event.event_id, stream_name: stream, expected_version: :any)
  end
end
