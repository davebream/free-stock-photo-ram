require 'dry-struct'

class Command < Dry::Struct
  Invalid = Class.new(StandardError)

  def self.new(*)
    super
  rescue Dry::Struct::Error => e
    raise Invalid, e
  end

  def self.inherited(klass)
    super
    klass.attribute :message_id, Types::UUID.default { SecureRandom.uuid }
    klass.attribute :correlation_id, Types::UUID.default { nil }
    klass.attribute :causation_id, Types::UUID.default { nil }
  end

  def correlate_with(other_message)
    self.correlation_id = other_message.correlation_id || other_message.message_id
    self.causation_id   = other_message.message_id
  end

  def data
    to_h.except(:message_id)
  end

  def ==(other)
    other.instance_of?(self.class) && other.data.eql?(data)
  end

  alias_method :eql?, :==
end
