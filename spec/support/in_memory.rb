module InMemoryHelpers
  FakeCommandBus = Class.new do
    attr_reader :received

    def call(command)
      @received = command
    end
  end

  def event_store
    @event_store ||= EventStore.in_memory
  end

  def command_bus
    @command_bus ||= FakeCommandBus.new
  end

  def cqrs
    @cqrs ||= CQRS.new(event_store, command_bus)
  end

  def with_events(events)
    events.each { |event| cqrs.event_store.append(event) }
    events
  end
end

RSpec.configure do |config|
  config.include InMemoryHelpers, in_memory: true
end
