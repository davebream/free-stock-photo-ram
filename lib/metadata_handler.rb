module MetadataHandler
  def perform(event)
    event_store.with_metadata(**event.metadata.to_h) do
      super
    end
  end

  def event_store
    Rails.configuration.event_store
  end
end
