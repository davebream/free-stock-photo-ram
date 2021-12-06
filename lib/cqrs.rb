class CQRS
  attr_reader :event_store

  def initialize(event_store, command_bus)
    @event_store = event_store
    @command_bus = command_bus
    @commands_to_events = {}
  end

  def subscribe(subscriber, events)
    @event_store.subscribe(subscriber, to: events)
  end

  def register_command(command, command_handler, events)
    @commands_to_events[command_handler] = events
    @command_bus.register(command, command_handler)
  end

  def register(command, command_handler)
    @command_bus.register(command, command_handler)
  end

  def run(command)
    @command_bus.call(command)
  end

  def link_event_to_stream(event, stream, expected_version = :any)
    @event_store.link(event.event_id, stream_name: stream, expected_version: expected_version)
  end

  def all_events_from_stream(name)
    event_store.read.stream(name).to_a
  end

  def to_hash
    @commands_to_events
  end
end
