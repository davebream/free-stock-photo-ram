module InMemoryIntegrationHelpers
  def event_store
    Rails.configuration.event_store
  end

  def command_bus
    Rails.configuration.command_bus
  end

  def cqrs
    Rails.configuration.cqrs
  end

  def run_command(command)
    cqrs.run(command)
  end

  def run_commands(commands)
    commands.each { |command| run_command(command) }
  end
end

RSpec.configure do |config|
  config.include InMemoryIntegrationHelpers, in_memory_integration: true

  config.around(:each, in_memory_integration: true) do |example|
    previous_event_store = Rails.configuration.event_store
    previous_command_bus = Rails.configuration.command_bus
    previous_cqrs = Rails.configuration.cqrs

    Rails.configuration.event_store = EventStore.in_memory
    Rails.configuration.command_bus = Arkency::CommandBus.new
    Rails.configuration.cqrs = CQRS.new(Rails.configuration.event_store, Rails.configuration.command_bus)

    ::Configuration.new.call(Rails.configuration.cqrs)

    example.run

    Rails.configuration.event_store = previous_event_store
    Rails.configuration.command_bus = previous_command_bus
    Rails.configuration.cqrs = previous_cqrs
  end
end
