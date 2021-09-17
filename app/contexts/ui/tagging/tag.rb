module UI
  module Tagging
    class Tag < ApplicationRecord
      self.table_name = 'read_model_tagging_tags'

      belongs_to :photo
    end
  end
end
