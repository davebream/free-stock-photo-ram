require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new(
    dispatcher: RubyEventStore::ComposedDispatcher.new(
      RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: RubyEventStore::SidekiqScheduler.new(serializer: YAML)),
      RubyEventStore::Dispatcher.new
    )
  )

  command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  ::Configuration.new.call(Rails.configuration.event_store, command_bus)

  Rails.configuration.command_bus = RubyEventStore::CorrelatedCommands.new(
    Rails.configuration.event_store,
    command_bus
  )
end
