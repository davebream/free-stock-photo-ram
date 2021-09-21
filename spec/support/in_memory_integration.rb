module InMemoryIntegrationHelpers
  def event_store
    Rails.configuration.event_store
  end

  def command_bus
    Rails.configuration.command_bus
  end

  def run_command(command)
    command_bus.call(command)
  end

  def run_commands(commands)
    commands.each { |command| run_command(command) }
  end

  def in_memory_event_store
    RailsEventStore::Client.new(
      repository: RubyEventStore::InMemoryRepository.new,
      dispatcher: RubyEventStore::ComposedDispatcher.new(
        RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: RubyEventStore::SidekiqScheduler.new(serializer: YAML)),
        RubyEventStore::Dispatcher.new
      )
    )
  end

  def in_memory_command_bus
    Arkency::CommandBus.new
  end
end

RSpec.configure do |config|
  config.include InMemoryIntegrationHelpers, in_memory_integration: true

  config.around(:each, in_memory_integration: true) do |example|
    previous_event_store = Rails.configuration.event_store
    previous_command_bus = Rails.configuration.command_bus

    Rails.configuration.event_store = in_memory_event_store
    Rails.configuration.command_bus = in_memory_command_bus

    Configuration.new.call(Rails.configuration.event_store, Rails.configuration.command_bus)

    example.run

    Rails.configuration.event_store = previous_event_store
    Rails.configuration.command_bus = previous_command_bus
  end
end
