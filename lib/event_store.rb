class EventStore < SimpleDelegator
  def self.in_memory
    new(
      RailsEventStore::Client.new(
        repository: RubyEventStore::InMemoryRepository.new,
        dispatcher: RubyEventStore::ComposedDispatcher.new(
          RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: RubyEventStore::SidekiqScheduler.new(serializer: YAML)),
          RubyEventStore::Dispatcher.new
        )
      )
    )
  end

  def link_event_to_stream(event, stream, expected_version: :any)
    __getobj__.link(
      event.event_id,
      stream_name: stream,
      expected_version: expected_version
    )
  end
end
