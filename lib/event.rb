class Event < Dry::Struct
  transform_keys(&:to_sym)

  def self.new(data: {}, metadata: {}, **rest)
    super(rest.merge(data).merge(metadata: metadata))
  end

  def self.inherited(klass)
    super
    klass.attribute :metadata, Types.Constructor(RubyEventStore::Metadata).default { RubyEventStore::Metadata.new }
    klass.attribute :event_id, Types::UUID.default { SecureRandom.uuid }
  end

  def timestamp
    metadata[:timestamp]
  end

  def valid_at
    metadata[:valid_at]
  end

  def data
    to_h.except(:event_id, :metadata)
  end

  def event_type
    self.class.name
  end

  def message_id
    event_id
  end

  def correlation_id
    metadata[:correlation_id]
  end

  def correlation_id=(val)
    metadata[:correlation_id] = val
  end

  def causation_id
    metadata[:causation_id]
  end

  def causation_id=(val)
    metadata[:causation_id] = val
  end

  def correlate_with(other_message)
    self.correlation_id = other_message.correlation_id || other_message.message_id
    self.causation_id   = other_message.message_id
  end

  def ==(other)
    other.instance_of?(self.class) &&
      other.event_id.eql?(event_id) &&
      other.data.eql?(data)
  end

  alias_method :eql?, :==
end
