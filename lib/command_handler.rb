module CommandHandler
  def self.included(base)
    base.class_eval do
      include Dry::Monads[:result]
    end
  end

  def call(command)
    __send__(command.class.name.demodulize.underscore, command)
  end

  def with_aggregate(aggregate_class, aggregate_id, &block)
    repository = AggregateRoot::InstrumentedRepository.new(AggregateRoot::Repository.new(event_store), ActiveSupport::Notifications)
    aggregate = aggregate_class.new(aggregate_id)
    stream = stream_name(aggregate_class, aggregate_id)
    repository.with_aggregate(aggregate, stream, &block)
  end

  def stream_name(aggregate_class, aggregate_id)
    "#{aggregate_class.name}$#{aggregate_id}"
  end

  def with_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  private

  def event_store
    Rails.configuration.event_store
  end
end
