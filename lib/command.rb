require 'dry-struct'

class Command < Dry::Struct
  Invalid = Class.new(StandardError)

  def self.new(*)
    super
  rescue Dry::Struct::Error => e
    raise Invalid, e
  end
end
