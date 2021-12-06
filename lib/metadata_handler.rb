module MetadataHandler
  def perform(event)
    Rails.configuration.cqrs.event_store.with_metadata(**event.metadata.to_h) do
      super
    end
  end
end
