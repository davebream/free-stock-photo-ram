module CommandHandler
  private

  def event_store
    Rails.configuration.event_store
  end

  def repository
    @repository ||= AggregateRoot::Repository.new(event_store)
  end

  def with_aggregate(klass, id, &block)
    # klass_name_demodularized = klass.name.split('::').last
    # stream_name = "#{klass_name_demodularized}$#{id}"
    stream_name = "#{klass.name}$#{id}"

    repository.with_aggregate(klass.new(id), stream_name, &block)
  end
end
