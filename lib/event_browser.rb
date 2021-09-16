EventBrowser = RubyEventStore::Browser::App.for(
  related_streams_query: RelatedStreamsQuery.new,
  event_store_locator: -> { Rails.configuration.event_store }
)
