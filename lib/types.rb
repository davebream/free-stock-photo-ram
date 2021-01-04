# frozen_string_literal: true

# rubocop:disable Style/RedundantParentheses

require 'dry-types'

Dry::Types.load_extensions(:maybe)

module Types
  include Dry.Types(default: :nominal)

  UUID_FORMAT =
    (/\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/i)
    .freeze

  UUID = Types::Strict::String.constrained(format: UUID_FORMAT)
end
