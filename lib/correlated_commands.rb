class CorrelatedCommands
  def initialize(event_store, command_bus)
    @event_store = event_store
    @command_bus = command_bus
  end

  MiniEvent = Struct.new(:correlation_id, :message_id)

  def call(command)
    correlation_id = event_store.metadata[:correlation_id]
    causation_id = event_store.metadata[:causation_id]

    if correlation_id && causation_id
      command.correlate_with(MiniEvent.new(correlation_id, causation_id)) if command.respond_to?(:correlate_with)
      with_causation(command) { command_bus.call(command) }
    else
      with_correlation_and_causation(command) { command_bus.call(command) }
    end
  end

  private

  attr_reader :event_store, :command_bus

  def with_causation(command, &block)
    event_store.with_metadata(causation_id: command.message_id, &block)
  end

  def with_correlation_and_causation(command, &block)
    correlation_id = command.correlation_id || command.message_id
    causation_id = command.message_id
    event_store.with_metadata(correlation_id: correlation_id, causation_id: causation_id, &block)
  end
end
